/*! @file OIDExternalUserAgentIOS.m
    @brief AppAuth iOS SDK
    @copyright
        Copyright 2016 Google Inc. All Rights Reserved.
    @copydetails
        Licensed under the Apache License, Version 2.0 (the "License");
        you may not use this file except in compliance with the License.
        You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

        Unless required by applicable law or agreed to in writing, software
        distributed under the License is distributed on an "AS IS" BASIS,
        WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
        See the License for the specific language governing permissions and
        limitations under the License.
 */

#import "OIDExternalUserAgentIOS.h"

#import <SafariServices/SafariServices.h>
#import <AuthenticationServices/AuthenticationServices.h>

#import "OIDErrorUtilities.h"
#import "OIDExternalUserAgentSession.h"
#import "OIDExternalUserAgentRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIDExternalUserAgentIOS ()<SFSafariViewControllerDelegate>
@end

@implementation OIDExternalUserAgentIOS {
  UIViewController *_presentingViewController;

  BOOL _externalUserAgentFlowInProgress;
  __weak id<OIDExternalUserAgentSession> _session;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
  __weak SFSafariViewController *_safariVC;
  SFAuthenticationSession *_authenticationVC;
  ASWebAuthenticationSession *_webAuthenticationVC;
#pragma clang diagnostic pop
}

- (nullable instancetype)initWithPresentingViewController:
        (UIViewController *)presentingViewController {
  self = [super init];
  if (self) {
    _presentingViewController = presentingViewController;
  }
  return self;
}

- (BOOL)presentExternalUserAgentRequest:(id<OIDExternalUserAgentRequest>)request
                                session:(id<OIDExternalUserAgentSession>)session {
  if (_externalUserAgentFlowInProgress) {
    // TODO: Handle errors as authorization is already in progress.
    return NO;
  }

  _externalUserAgentFlowInProgress = YES;
  _session = session;
  BOOL openedSafari = NO;
  NSURL *requestURL = [request externalUserAgentRequestURL];

  // iOS 12 and later, use ASWebAuthenticationSession
  if (@available(iOS 12.0, *)) {
    __weak OIDExternalUserAgentIOS *weakSelf = self;
    NSString *redirectScheme = request.redirectScheme;
    ASWebAuthenticationSession *authenticationVC =
        [[ASWebAuthenticationSession alloc] initWithURL:requestURL
                                      callbackURLScheme:redirectScheme
                                       completionHandler:^(NSURL * _Nullable callbackURL,
                                                           NSError * _Nullable error) {
      __strong OIDExternalUserAgentIOS *strongSelf = weakSelf;
      if (!strongSelf) {
          return;
      }
      strongSelf->_webAuthenticationVC = nil;
      if (callbackURL) {
        [strongSelf->_session resumeExternalUserAgentFlowWithURL:callbackURL];
      } else {
        NSError *safariError =
            [OIDErrorUtilities errorWithCode:OIDErrorCodeUserCanceledAuthorizationFlow
                             underlyingError:error
                                 description:nil];
        [strongSelf->_session failExternalUserAgentFlowWithError:safariError];
      }
    }];
    _webAuthenticationVC = authenticationVC;
    openedSafari = [authenticationVC start];
  // iOS 11, use SFAuthenticationSession
  } else if (@available(iOS 11.0, *)) {
    __weak OIDExternalUserAgentIOS *weakSelf = self;
    NSString *redirectScheme = request.redirectScheme;
    SFAuthenticationSession *authenticationVC =
        [[SFAuthenticationSession alloc] initWithURL:requestURL
                                   callbackURLScheme:redirectScheme
                                   completionHandler:^(NSURL * _Nullable callbackURL,
                                                       NSError * _Nullable error) {
      __strong OIDExternalUserAgentIOS *strongSelf = weakSelf;
      if (!strongSelf) {
          return;
      }
      strongSelf->_authenticationVC = nil;
      if (callbackURL) {
        [strongSelf->_session resumeExternalUserAgentFlowWithURL:callbackURL];
      } else {
        NSError *safariError =
            [OIDErrorUtilities errorWithCode:OIDErrorCodeUserCanceledAuthorizationFlow
                             underlyingError:error
                                 description:@"User cancelled."];
        [strongSelf->_session failExternalUserAgentFlowWithError:safariError];
      }
    }];
    _authenticationVC = authenticationVC;
    openedSafari = [authenticationVC start];
  // iOS 9 and 10, use SFSafariViewController
  } else if (@available(iOS 9.0, *)) {
    SFSafariViewController *safariVC =
        [[SFSafariViewController alloc] initWithURL:requestURL];
    safariVC.delegate = self;
    _safariVC = safariVC;
    [_presentingViewController presentViewController:safariVC animated:YES completion:nil];
    openedSafari = YES;
  // iOS 8 and earlier, use mobile Safari
  } else {
    openedSafari = [[UIApplication sharedApplication] openURL:requestURL];
  }

  if (!openedSafari) {
    [self cleanUp];
    NSError *safariError = [OIDErrorUtilities errorWithCode:OIDErrorCodeSafariOpenError
                                            underlyingError:nil
                                                description:@"Unable to open Safari."];
    [session failExternalUserAgentFlowWithError:safariError];
  }
  return openedSafari;
}

- (void)dismissExternalUserAgentAnimated:(BOOL)animated completion:(void (^)(void))completion {
  if (!_externalUserAgentFlowInProgress) {
    // Ignore this call if there is no authorization flow in progress.
    return;
  }
  
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
  SFSafariViewController *safariVC = _safariVC;
  SFAuthenticationSession *authenticationVC = _authenticationVC;
  ASWebAuthenticationSession *webAuthenticationVC = _webAuthenticationVC;
#pragma clang diagnostic pop
  
  [self cleanUp];
  
  if (@available(iOS 12.0, *)) {
    // dismiss the ASWebAuthenticationSession
    [webAuthenticationVC cancel];
    if (completion) completion();
  } else if (@available(iOS 11.0, *)) {
    // dismiss the SFAuthenticationSession
    [authenticationVC cancel];
    if (completion) completion();
  } else if (@available(iOS 9.0, *)) {
    // dismiss the SFSafariViewController
    if (safariVC) {
      [safariVC dismissViewControllerAnimated:YES completion:completion];
    } else {
      if (completion) completion();
    }
  } else {
    if (completion) completion();
  }
}

- (void)cleanUp {
  // The weak references to |_safariVC| and |_session| are set to nil to avoid accidentally using
  // them while not in an authorization flow.
  _safariVC = nil;
  _authenticationVC = nil;
  _session = nil;
  _externalUserAgentFlowInProgress = NO;
}

#pragma mark - SFSafariViewControllerDelegate

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller NS_AVAILABLE_IOS(9.0) {
  if (controller != _safariVC) {
    // Ignore this call if the safari view controller do not match.
    return;
  }
  if (!_externalUserAgentFlowInProgress) {
    // Ignore this call if there is no authorization flow in progress.
    return;
  }
  id<OIDExternalUserAgentSession> session = _session;
  [self cleanUp];
  NSError *error = [OIDErrorUtilities errorWithCode:OIDErrorCodeUserCanceledAuthorizationFlow
                                    underlyingError:nil
                                        description:@"No external user agent flow in progress."];
  [session failExternalUserAgentFlowWithError:error];
}

@end

NS_ASSUME_NONNULL_END
