# SmartCredentials iOS Coding Standards

The coding standards of the SmartCredentials library are inspired from the official [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) and [The Official raywenderlich.com Swift Style Guide](https://github.com/raywenderlich/swift-style-guide).

## 1. Code
### 1.1. Naming
Descriptive and consistent naming makes software easier to read and understand. Use the Swift naming conventions described in the [API Design Guidelines](https://swift.org/documentation/api-design-guidelines/). Some key takeaways include:
- using camel case (not snake case)
- using uppercase for types (and protocols), lowercase for everything else
- naming variables, parameters, and associated types according to their roles, rather than their type constraints
- including all the words needed to avoid ambiguity for a person reading code where the name is used
- naming methods for their side effects
  - verb methods follow the -ed, -ing rule for the non-mutating version
  - noun methods follow the formX rule for the mutating version
  - boolean types should read like assertions
- generally avoiding abbreviations
- casing acronyms and initialisms uniformly up or down
- choosing good parameter names that serve as documentation

#### 1.1.1. Delegates
When creating custom delegate methods, an unnamed first parameter should be the delegate source. (UIKit contains numerous examples of this.)

**Preferred**:
```swift
func namePickerView(_ namePickerView: NamePickerView, didSelectName name: String)
func namePickerViewShouldReload(_ namePickerView: NamePickerView) -> Bool
```
**Not Preferred**:
```swift
func didSelectName(namePicker: NamePickerViewController, name: String)
func namePickerShouldReload() -> Bool
```

#### 1.1.2. Use Type Inferred Context
Use compiler inferred context to write shorter, clear code. 

**Preferred**:
```swift
let selector = #selector(viewDidLoad)
view.backgroundColor = .red
let toView = context.view(forKey: .to)
let view = UIView(frame: .zero)
```
**Not Preferred**:
```swift
let selector = #selector(ViewController.viewDidLoad)
view.backgroundColor = UIColor.red
let toView = context.view(forKey: UITransitionContextViewKey.to)
let view = UIView(frame: CGRect.zero)
```

#### 1.1.3. Language
Use US English spelling to match Apple's API.

**Preferred**:
```swift
let color = "red"
```
**Not Preferred**:
```swift
let colour = "red"
```

### 1.2. Code Organization
Use extensions to organize your code into logical blocks of functionality. Each extension should be set off with a `// MARK: -` comment to keep things well-organized.

#### 1.2.1. Protocol Conformance
In particular, when adding protocol conformance to a model, prefer adding a separate extension for the protocol methods. This keeps the related methods grouped together with the protocol and can simplify instructions to add a protocol to a class with its associated methods.

**Preferred**:
```swift
class MyViewController: UIViewController {
  // class stuff here
}

// MARK: - UITableViewDataSource
extension MyViewController: UITableViewDataSource {
  // table view data source methods
}

// MARK: - UIScrollViewDelegate
extension MyViewController: UIScrollViewDelegate {
  // scroll view delegate methods
}
```
**Not Preferred**:
```swift
class MyViewController: UIViewController, UITableViewDataSource, UIScrollViewDelegate {
  // all methods
}
```

#### 1.2.2. Unused Code
Unused (dead) code, including Xcode template code and placeholder comments should be removed. An exception is when your tutorial or book instructs the user to use the commented code.

#### 1.2.3. Minimal Imports
Import only the modules a source file requires. For example, don't import `UIKit` when importing `Foundation` will suffice. Likewise, don't import `Foundation` if you must import `UIKit`.

**Preferred**:
```swift
import UIKit
var view: UIView
var deviceModels: [String]
```
**Preferred**:
```swift
import Foundation
var deviceModels: [String]
```
**Not Preferred**:
```swift
import UIKit
import Foundation
var view: UIView
var deviceModels: [String]
```
**Not Preferred**:
```swift
import UIKit
var deviceModels: [String]
```

### 1.3. Spacing
* Indent using 2 spaces rather than tabs to conserve space and help prevent line wrapping. Be sure to set this preference in Xcode and in the Project settings.
* Method braces and other braces (`if`/`else`/`switch`/`while` etc.) always open on the same line as the statement but close on a new line.
* Tip: You can re-indent by selecting some code (or **Command-A** to select all) and then **Control-I** (or **Editor ▸ Structure ▸ Re-Indent** in the menu). Some of the Xcode template code will have 4-space tabs hard coded, so this is a good way to fix that.

**Preferred**:
```swift
if user.isHappy {
  // Do something
} else {
  // Do something else
}
```
**Not Preferred**:
```swift
if user.isHappy
{
  // Do something
}
else {
  // Do something else
}
```

* There should be exactly one blank line between methods to aid in visual clarity and organization. Whitespace within methods should separate functionality, but having too many sections in a method often means you should refactor into several methods.
* There should be no blank lines after an opening brace or before a closing brace.
* Colons always have no space on the left and one space on the right. Exceptions are the ternary operator `? :`, empty dictionary `[:]` and `#selector` syntax `addTarget(_:action:)`.

**Preferred**:
```swift
class TestDatabase: Database {
  var data: [String: CGFloat] = ["A": 1.2, "B": 3.2]
}
```
**Not Preferred**:
```swift
class TestDatabase : Database {
  var data :[String:CGFloat] = ["A" : 1.2, "B":3.2]
}
```

* Long lines should be wrapped at around 70 characters. A hard limit is intentionally not specified.
* Avoid trailing whitespaces at the ends of lines.
* Add a single newline character at the end of each file.

### 1.4. Use of self
For conciseness, avoid using `self` since Swift does not require it to access an object's properties or invoke its methods.

Use self only when required by the compiler (in `@escaping` closures, or in initializers to disambiguate properties from arguments). In other words, if it compiles without `self` then omit it.

### 1.5. Function Declarations
Keep short function declarations on one line including the opening brace:

```swift
func reticulateSplines(spline: [Double]) -> Bool {
  // reticulate code goes here
}
```

For functions with long signatures, put each parameter on a new line and add an extra indent on subsequent lines:

```swift
func reticulateSplines(
  spline: [Double], 
  adjustmentFactor: Double,
  translateConstant: Int, comment: String
) -> Bool {
  // reticulate code goes here
}
```

### 1.6. Function Calls
Mirror the style of function declarations at call sites. Calls that fit on a single line should be written as such:

```swift
let success = reticulateSplines(splines)
```

If the call site must be wrapped, put each parameter on a new line, indented one additional level:

```swift
let success = reticulateSplines(
  spline: splines,
  adjustmentFactor: 1.3,
  translateConstant: 2,
  comment: "normalize the display")
```

### 1.7. Types
Always use Swift's native types and expressions when available. Swift offers bridging to Objective-C so you can still use the full set of methods as needed.

**Preferred**:
```swift
let width = 120.0                                    // Double
let widthString = "\(width)"                         // String
```
**Less Preferred**:
```swift
let width = 120.0                                    // Double
let widthString = (width as NSNumber).stringValue    // String
```
**Not Preferred**:
```swift
let width: NSNumber = 120.0                          // NSNumber
let widthString: NSString = width.stringValue        // NSString
```

### 1.8. Constants
Constants are defined using the `let` keyword and variables with the `var` keyword. Always use `let` instead of `var` if the value of the variable will not change.

**Tip:** A good technique is to define everything using `let` and only change it to `var` if the compiler complains!

You can define constants on a type rather than on an instance of that type using type properties. To declare a type property as a constant simply use `static let`. Type properties declared in this way are generally preferred over global constants because they are easier to distinguish from instance properties. Example:

**Preferred**:
```swift
enum Math {
  static let e = 2.718281828459045235360287
  static let root2 = 1.41421356237309504880168872
}

let hypotenuse = side * Math.root2
```
**Note:** The advantage of using a case-less enumeration is that it can't accidentally be instantiated and works as a pure namespace.

**Not Preferred**:
```swift
let e = 2.718281828459045235360287  // pollutes global namespace
let root2 = 1.41421356237309504880168872

let hypotenuse = side * root2 // what is root2?
```

### 1.9. Type Inference
Prefer compact code and let the compiler infer the type for constants or variables of single instances. Type inference is also appropriate for small, non-empty arrays and dictionaries. When required, specify the specific type such as `CGFloat` or `Int16`.

**Preferred**:
```swift
let message = "Click the button"
let currentBounds = computeViewBounds()
var names = ["Mic", "Sam", "Christine"]
let maximumWidth: CGFloat = 106.5
```
**Not Preferred**:
```swift
let message: String = "Click the button"
let currentBounds: CGRect = computeViewBounds()
var names = [String]()
```

### 1.10. Type Annotation for Empty Arrays and Dictionaries
For empty arrays and dictionaries, use type annotation. (For an array or dictionary assigned to a large, multi-line literal, use type annotation.)

**Preferred**:
```swift
var names: [String] = []
var lookup: [String: Int] = [:]
```
**Not Preferred**:
```swift
var names = [String]()
var lookup = [String: Int]()
```

### 1.11. Syntactic Sugar
Prefer the shortcut versions of type declarations over the full generics syntax.

**Preferred**:
```swift
var deviceModels: [String]
var employees: [Int: String]
var faxNumber: Int?
```
**Not Preferred**:
```swift
var deviceModels: Array<String>
var employees: Dictionary<Int, String>
var faxNumber: Optional<Int>
```

### 1.12. Control Flow
Prefer the `for-in` style of `for` loop over the `while-condition-increment` style.

**Preferred**:
```swift
for _ in 0..<3 {
  print("Hello three times")
}

for (index, person) in attendeeList.enumerated() {
  print("\(person) is at position #\(index)")
}

for index in stride(from: 0, to: items.count, by: 2) {
  print(index)
}

for index in (0...3).reversed() {
  print(index)
}
```
**Not Preferred**:
```swift
var i = 0
while i < 3 {
  print("Hello three times")
  i += 1
}

var i = 0
while i < attendeeList.count {
  let person = attendeeList[i]
  print("\(person) is at position #\(i)")
  i += 1
}
```

### 1.13. Semicolons
Swift does not require a semicolon after each statement in your code. They are only required if you wish to combine multiple statements on a single line.

Do not write multiple statements on a single line separated with semicolons.

**Preferred**:
```swift
let swift = "not a scripting language"
```
**Not Preferred**:
```swift
let swift = "not a scripting language";
```

### 1.14. Parentheses
Parentheses around conditionals are not required and should be omitted.

**Preferred**:
```swift
if name == "Hello" {
  print("World")
}
```
**Not Preferred**:
```swift
if (name == "Hello") {
  print("World")
}
```

In larger expressions, optional parentheses can sometimes make code read more clearly.

**Preferred**:
```swift
let playerMark = (player == current ? "X" : "O")
```

## 2. Documentation

### 2.1. Copyright Statement
The following copyright statement should be included at the top of every source
file:
```swift
/*
 * Copyright (c) 2019 Telekom Deutschland AG
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 ```

### 2.2. Comments
When they are needed, use comments to explain **why** a particular piece of code does something. Comments must be kept up-to-date or deleted.

Avoid block comments inline with code, as the code should be as self-documenting as possible. _Exception: This does not apply to those comments used to generate documentation._

Avoid the use of C-style comments (`/* ... */`). Prefer the use of double- or triple-slash.

## 3. Version control
No commented out code must be committed unless you have a very good reason that is clearly described in a comment by the code you are ommitting.
