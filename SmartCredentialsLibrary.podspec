#
#  Be sure to run `pod spec lint SmartCredentialsLibrary.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.

Pod::Spec.new do |s|

  s.name         = 'SmartCredentialsLibrary'
  s.version      = "5.3.4"
  s.summary      = "Smart Credentials is a library with multiple generic functionalities, like secure storage, authorization, camera scanners and more."

  s.description  = <<-DESC
Smart Credentials is a library with multiple generic functionalities. The focus is on having components that are not application-specific, so that they can be easily integrated into multiple applications.
The main feature of the library is the secure storage. The library itself is data type – agnostic and can handle both sensitive and plain user data. Based on the data definition, the library has internal mechanisms to retrieve/store content or manipulate data pieces.
Other features include QR-based login, barcode reader, OCR reader/parser, OTP generator, fingerprint/pin/pattern/faceId authorization.
                   DESC

  s.homepage     = "https://github.com/telekom/SmartCredentials-SDK-ios.git"
  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }

  s.author             = "Deutsche Telekom AG"

  s.platform     = :ios
  s.ios.deployment_target = '9.0'
  s.swift_version = "5.0"

  s.source       = { :git => "https://github.com/telekom/SmartCredentials-SDK-ios.git", :tag => "#{s.version}" }
  # s.source_files  = ['SmartCredentials/Core/Core/**/*.{h,swift}', 
  #   'SmartCredentials/Storage/**/*.{h,swift}', 
  #   'SmartCredentials/Encryption/**/*.{h,swift}',
  #   'SmartCredentials/Authorization/**/*.{h,swift}',
  #   'SmartCredentials/CameraScanner/**/*.{h,swift,framework}',
  #   'SmartCredentials/Networking/**/*.{h,m,swift}',
  #   'SmartCredentials/QRLogin/**/*.{h,swift}',
  #   'SmartCredentials/OTP/**/*.{swift}',
  #   'SmartCredentials/Authentication/Authentication/**/*.{h,swift}',
  # ]
  s.exclude_files = 'SmartCredentials/Authentication/AppAuth/'

  # Core
  s.subspec 'Core' do |sp|
    sp.source_files  = 'SmartCredentials/Core/Core/**/*.{h,swift}'
  end

  # Authentication
  s.subspec 'Authentication' do |sp|
    sp.source_files  = 'SmartCredentials/Authentication/Authentication/**/*.{h,swift}'
    sp.dependency 'SmartCredentialsLibrary/Core'
    sp.dependency 'AppAuth'
  end

  # Authorization
  s.subspec 'Authorization' do |sp|
    sp.source_files  = 'SmartCredentials/Authorization/**/*.{h,swift}'
    sp.dependency 'SmartCredentialsLibrary/Core'
  end

  # CameraScanner
  s.subspec 'CameraScanner' do |sp|
    sp.source_files  = 'SmartCredentials/CameraScanner/**/*.{h,swift,framework}'
    sp.dependency 'SmartCredentialsLibrary/Core'
    sp.dependency 'TesseractOCRiOS'
  end

  # # # DocumentScanner
  # s.subspec 'DocumentScanner' do |sp|
  #   sp.source_files  = 'SmartCredentials/DocumentScanner/**/*.swift'
  #   sp.dependency 'SmartCredentialsLibrary/Core'
  #   sp.framework = 'MicroBlink.framework'
  # end

  # Encryption
  s.subspec 'Encryption' do |sp|
    sp.source_files  = 'SmartCredentials/Encryption/**/*.{h,swift}'
    sp.dependency 'SmartCredentialsLibrary/Core'
  end

  # Networking
  s.subspec 'Networking' do |sp|
    sp.source_files  = 'SmartCredentials/Networking/**/*.{h,m,swift}'
    sp.dependency 'SmartCredentialsLibrary/Core'
  end

  # OTP
  s.subspec 'OTP' do |sp|
    sp.source_files  = 'SmartCredentials/OTP/**/*.swift'
    sp.dependency 'SmartCredentialsLibrary/Core'
    sp.dependency 'SmartCredentialsLibrary/CameraScanner'
    sp.dependency 'SmartCredentialsLibrary/Storage' 
  end

  # QRLogin
  s.subspec 'QRLogin' do |sp|
    sp.source_files  = 'SmartCredentials/QRLogin/**/*.{h,swift,framework}'
    sp.dependency 'SmartCredentialsLibrary/Core'
    sp.dependency 'SmartCredentialsLibrary/Authorization'
    sp.dependency 'Starscream'
  end

  # Storage
  s.subspec 'Storage' do |sp|
    sp.source_files  = 'SmartCredentials/Storage/Storage/**/*.{h,swift,xcdatamodeld}'
    sp.dependency 'SmartCredentialsLibrary/Core'
    
    sp.resource_bundles = {'CredentialsModel' => ['SmartCredentials/**/*.xcdatamodeld']}
  	sp.resources = 'SmartCredentials/**/*.xcdatamodeld'
  end

end
