#  Usage of the Smart Credentials Identity Provider API
Smart Credentials Identity Provider Module is used for obtaining operator token from the partner application.

**Add Identity Provider module to your project**
1. Create a .framework file by archiving the IdentityProvider module and add the original files (for both IndentityProvider and Core) to your project.
2. Import Core module and IdentityProvider module in the desired class.
```swift
import Core
import IdentityProvider
````

**Obtaining Operator Token**
Initialize the module

```swift
let configuration = SmartCredentialsConfiguration(userId: "user_id", logger: DemoLogger(), jailbreakCheckEnabled: true)
let identityProvider = SmartCredentialsIdentityProviderFactory.smartCredentialsIdentityProviderAPI(configuration: configuration)
````

Fetch Operator Token

```swift
identityProvider.getOperatorToken(appToken: appToken, clientId: clientId, scope: scope, universalLink: universalLink) { result in
    switch result {
    case .success(result: let operatorToken):
        // Handle your success case
    case .failure(error: let error):
        // Handle your error case
    }
}
````
