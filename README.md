# SmartCredentials-SDK-ios

Smart Credentials is a library with multiple generic functionalities. The focus is on having
components that are not application-specific, so that they can be easily integrated into multiple
applications.

Objects that are used in SmartCredentialsLibrary are called credentials. “Items” term is also used to
refer to credentials or any other generic type of object that can be stored in the library.
SmartCredentials is a generic library that aims to make credentials more intelligent by enabling
different actions on it and it also keeps them as generic as they can be. So the items is a more
generic term for referring to smart credentials objects.

One of the library’s purpose is to assists applications with retrieving and storing user related data. The
library itself is data type – agnostic and can handle both sensitive and plain user data. Based on the
data definition, the library has internal mechanisms to retrieve/store content or manipulate data
pieces.

Other features include QR-based login, barcode reader, OCR reader/parser, OTP generator,
fingerprint/pin/pattern/faceId authorization.

The files of the project SmartCredentials-SDK-ios are licensed under the
Apache-2.0 license. For details see the file 'LICENSE' on the top level of the repository.

## Usage
**Initialization of the core module.** 
```swift
let configuration = SmartCredentialsConfiguration(userId: "user_id", logger: DemoLogger(), jailbreakCheckEnabled: true)
let core = SmartCredentialsCoreFactory.smartCredentialsCoreAPI(configuration: configuration)
```
The userId parameter is your desired id, the boolean from jailbreakCheckEnabled decides wheter the Jailbreak Checker functionality is enabled or not. The core is an instance of the a Core module that could be used to perform several actions, non-related to specific modules.

**Initialization and usage of Smart Credentials modules**
Each module should be instantiated using their own factory classes either in the components in which they are used or on the application level. 

Authentication Module
```swift
let configuration = SmartCredentialsConfiguration(userId: "user_id", logger: DemoLogger(), jailbreakCheckEnabled: true)
let authentication = SmartCredentialsAuthenticationFactory.smartCredentialsAuthenticationAPI(configuration: configuration)
// Use the Authenticaion API
````
Authorization Module
```swift
let configuration = SmartCredentialsConfiguration(userId: "user_id", logger: DemoLogger(), jailbreakCheckEnabled: true)
let authorization = SmartCredentialsAuthorizationFactory.smartCredentialsAuthorizationAPI(configuration: configuration)
// Use the Authorization API
````
CameraScanner Module
```swift
let configuration = SmartCredentialsConfiguration(userId: "user_id", logger: DemoLogger(), jailbreakCheckEnabled: true)
let cameraScanner = SmartCredentialsCameraScannerFactory.smartCredentialsCameraScannerAPI(configuration: configuration)
// Use the CameraScanner API
````
DocumentScanner Module
```swift
let configuration = SmartCredentialsConfiguration(userId: "user_id", logger: DemoLogger(), jailbreakCheckEnabled: true)
let documentScanner = SmartCredentialsDocumentScannerFactory.smartCredentialsDocumentScannerAPI(configuration: configuration, license: license, licensee: licensee)
// Use the DocumentScanner API
````
Encryption Module
```swift
let configuration = SmartCredentialsConfiguration(userId: "user_id", logger: DemoLogger(), jailbreakCheckEnabled: true)
let encryption = SmartCredentialsEncryptionFactory.smartCredentialsEncryptionAPI(configuration: configuration)
// Use the Encryption API
````
Networking Module
```swift
let configuration = SmartCredentialsConfiguration(userId: "user_id", logger: DemoLogger(), jailbreakCheckEnabled: true)
let networking = SmartCredentialsNetworkingFactory.smartCredentialsNetworkingAPI(for: configuration, connectionType: .overWiFi)
// Use the Networking API
````
OTP Module
```swift
let configuration = SmartCredentialsConfiguration(userId: "user_id", logger: DemoLogger(), jailbreakCheckEnabled: true)
let otp = SmartCredentialsOTPFactory.smartCredentialsOTPAPI(configuration: configuration, storage: storage, cameraScanner: cameraScanner)
// Use the OTP API
````
QRLogin Module
```swift
let configuration = SmartCredentialsConfiguration(userId: "user_id", logger: DemoLogger(), jailbreakCheckEnabled: true)
let qrLogin = SmartCredentialsQRLoginFactory.smartCredentialsQRLoginAPI(configuration: configuration, authorization: authorization)
// Use the QRLogin API
````
Storage Module
```swift
let configuration = SmartCredentialsConfiguration(userId: "user_id", logger: DemoLogger(), jailbreakCheckEnabled: true)
let storage = SmartCredentialsStorageFactory.smartCredentialsStorageAPI(configuration: configuration)
// Use the Storage Api (see the example below)
````

Example of working with Smart Credentials Storage API
```swift
// Create an Item Envelope
let itemEnvelope = ItemEnvelopeFactory.itemEnvelope(with: itemId,
                                                    type: itemType,
                                                    identifier: identifier,
                                                    privateData: privateData)

// Create an Item Context that specifies the place where it will be stored
let itemContext = ItemContextFactory.itemContext(with: .sensitive)

// Creates an Item Filter in regards to an item content type and item id (for single item operations). This filter specifies the place where the items are held.
let itemFilter = ItemFilterFactory.itemFilter(with: itemId, contentType: .sensitive)

// Insert an item in the database
_ = storage.put(itemEnvelope, with: itemContext)

// Updates an item from the database
_ = storage.update(itemEnvelope, with: itemContext)

// Deletes an item from the database
_ = storage.removeItem(for: itemFilter)

// Retrieve all items according to a filter
let getItemsResult = storage.getAllItems(for: ItemFilterFactory.itemFilter())
switch getItemsResult {
case .success(let items):
    // handle items list
case .failure(let error):
    // handle error
}
````

## Support

Discussions about the SmartCredentials library take place on this [Slack](https://smartcredentialssdk.slack.com/) channel. Anybody is welcome to join these conversations. 

## Contributing

We are open for any contribution on the topic of credential management, authentication and user-centric identity.
Even more are we looking for partners who have an interest in adding their solutions to the list of existing modules. However, if you have good reason to think it would be good to have **someone else's solution** adapted, you might just be the person who simply does it. Just make sure you are **allowed** to handle the code or executable in question.

Pull requests for small improvements or bug fixing are welcomed. For major changes, please open an issue first to discuss what you would like to change.

In case of contributing, please check the [contributing guidelines](https://github.com/kreincke/SmartCredentials-SDK-ios/blob/develop/CONTRIBUTING.md) and [coding standards](https://github.com/kreincke/SmartCredentials-SDK-ios/blob/develop/CODING-STANDARDS-IOS.md).

## Extending
Smart Credentials is an open and easily extendable library. In fact, it is so open and extendable that anyone can come with a parallel implementation of any module, except the core module.

By using Smart Credentials to build your module, not only you save time and energy for your implementation by making use of the existing features, but the new created module can also be used by others in combination with any of Smart Credentials existing modules.

Currently, there are 9 extendable modules:

1. Authentication
2. Authorization
3. Camera
4. Document scanner
5. Encryption
6. Networking
7. Otp
8. QR login
9. Storage

In order to implement your own module you have to follow the next steps:

### 1. Add Smart Credentials Core module as a dependency:
```
to be added
```

### 2. Implement the API interface from Core module

The API interface exposes an unified and standard protocol for the Smart Credentials SDK, in regard to the the specific functionality you chose to extend.

### 3. Use exposed classes 

In the core module, beside the API, you will find different exposed classes for each module. They are intentionally left here for you in order to 
reuse the functionality and save a lot of time, or because they standardize some functionality or a way of declaring/delivering data.

You are advised to look over these classes before starting to extend a module and try to use these classes as much as you can.

### 4. Expose your API implementation

Don't forget to make you API implementation public to end-users and provide them with a way of creating an instance of your API implementation.

### 5. Congratulations
If you followed all the steps above and provided a working implementation for the APIs, you should have your own Smart Credentials module!

## Authors and acknowledgment
Main contributors to the vision, the architecture, and code of SmartCredentials were: Jochen Klaffer, Zhiyun Ren, Axel Nennker and several others from the wallet projects under the auspices of Jörg Heuer.

## License
```
The code in this repository is licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
