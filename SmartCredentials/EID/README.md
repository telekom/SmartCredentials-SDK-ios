#  Usage of the Smart Credentials EID API
Smart Credentials EID Module is used for facilitating the usage of AusweisApp2 SDK.

**Add EID module to your project**
1. Create a .framework file by archiving the EID module and add the original files (for both EID and Core) to your project.
2. Import Core module and EID module in the desired class.
```swift
import Core
import EID
````

**Working with EID module**

Initialize the module

```swift
let configuration = SmartCredentialsConfiguration(userId: "user_id", logger: DemoLogger(), jailbreakCheckEnabled: true)
let eID = SmartCredentialsEIDFactory.smartCredentialsEIDAPI(configuration: configuration)
````

Initialize communication

```swift
self.eID.initialize(completionHandler: { message, error in
    // Handle received message or error
})
````

    Supported messages:
    1. AccessRightsMessage
    2. CertificateMessage
    3. InsertCardMessage
    4. ReaderMessage
    5. EnterCANMessage
    6. AuthMessage
    7. APILevelMessage
    8. ChangePINMessage
    9. EnterPINMessage
    10. EnterNewPINMessage
    11. EnterPUKMessage
    12. ReaderListMessage
    13. InfoMessage
    14. InternalErrorMessage
    15. InvalidMessage
    16. BadStateMessage
    17. StatusMessage
    18. UnknownCommandMessage

Create command

```swift
let getCertificateCmd = GetCertificateCommand(cmd: Commands.getCertificate.rawValue)
````

```swift
let acceptCmd = AcceptCommand(cmd: Commands.accept.rawValue)
````

    Supported commands
    1. GetInfoCommand
    2. GetStatusCommand
    3. GetAPILevelCommand
    4. SetAPILevelCommand
    5. GetReaderCommand
    6. GetReaderListCommand
    7. RunAuthCommand
    8. RunChangePINCommand
    9. GetAccessRightsCommand
    10. SetCardCommand
    11. GetCertificateCommand
    12. CancelCommand
    13. AcceptCommand
    14. InterruptCommand
    15. SetPINCommand
    16. SetNewPINCommand
    17. SetCANCommand
    18. SetPUKCommand


Send command

```swift
eID.sendCommand(getCertificateCmd) { error in
    guard error == nil else {
        // Handle error
        return
    }
    // Command successfully sent
}
````

```swift
eID.sendCommand(acceptCmd) { error in
    guard error == nil else {
        // Handle error
        return
    }
    // Command successfully sent
}
````

Shutdown communication
```swift
eID.shutdown()
````
