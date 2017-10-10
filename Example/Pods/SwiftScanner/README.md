<p align="center" >
  <img src="https://raw.githubusercontent.com/malcommac/SwiftScanner/develop/logo.png" width=210px height=204px alt="SwiftScanner" title="SwiftScanner">
</p>

[![Build Status](https://travis-ci.org/oarrabi/SwiftScanner.svg?branch=master)](https://travis-ci.org/oarrabi/SwiftScanner)
[![codecov](https://codecov.io/gh/oarrabi/SwiftScanner/branch/master/graph/badge.svg)](https://codecov.io/gh/oarrabi/SwiftScanner)
[![Platform](https://img.shields.io/badge/platform-osx-lightgrey.svg)](https://travis-ci.org/oarrabi/SwiftScanner)
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)](https://travis-ci.org/oarrabi/SwiftScanner)
[![Language: Swift](https://img.shields.io/badge/language-swift-orange.svg)](https://travis-ci.org/oarrabi/SwiftScanner)
[![CocoaPods](https://img.shields.io/cocoapods/v/SwiftScanner.svg)](https://cocoapods.org/pods/SwiftScanner)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)


# SwiftScanner
`SwiftScanner` is a pure native Swift implementation of a string scanner; with no dependecies, full unicode support (who does not love emoji?), lots of useful featurs and swift in mind, StringScanner is a good alternative to built-in Apple's `NSScanner`.

<p align="center" >★★ <b>Star our github repository to help us!</b> ★★</p>

## You also may like
-------

Do you like `SwiftRichString`? I'm also working on several other opensource libraries.

Take a look here:

* **[SwiftDate](https://github.com/malcommac/SwiftDate)** - Full features Dates & TimeZone management for iOS,macOS,tvOS and watchOS
* **[Hydra](https://github.com/malcommac/Hydra)** - Promise, Async/Await on sterioids!
* **[SwiftLocation](https://github.com/malcommac/SwiftLocation)** - CoreLocation and Beacon Monitoring on steroid!
* **[SwiftScanner](https://github.com/malcommac/SwiftScanner)** - String scanner in pure Swift with full unicode support
* **[SwiftSimplify](https://github.com/malcommac/SwiftSimplify)** - Tiny high-performance Swift Polyline Simplification Library
* **[SwiftMsgPack](https://github.com/malcommac/SwiftMsgPack)** - MsgPack Encoder/Decoder in Swit

## Main Features
SwiftScanner is initialized with a string and mantain an internal index used to navigate backward and forward through the string using two main concepts:

* `scan` to return string which also increment the internal index
* `peek` to return a string without incrementing the internal index

Results of these operations returns collected String or Indexes.
If operation fail due to an error (ie. `eof`, `notFound`, `invalidInt`...) and exception is thrown, in pure Swift style.

API Documentation
-------

* **[scanChar()](#scanChar)**
* **[scanInt()](#scanInt)**
* **[scanFloat()](#scanFloat)**
* **[scanHexInt()](#scanHexInt)**
* **[scan(upTo: UnicodeScalar)](#scanUpToChar)**
* **[scan(upTo: CharacterSet)](#scanUpToCharset)**
* **[scan(untilIn: CharacterSet)](#scanUntilInCharset)**
* **[scan(upTo: String)](#scanUpToString)**
* **[scan(until: Test)](#scanUntilTrue)**
* **[scan(length: Int)](#scanLenght)**
* **[peek(upTo: UnicodeScalar)](#peekUpToChar)**
* **[peek(upTo: CharacterSet)](#peekUpToCharset)**
* **[peek(untilIn: CharacterSet)](#peekUpUntilInCharset)**
* **[peek(upTo: String)](#peekUpToString)**
* **[peek(until: Test)](#peekUpUntil)**
* **[match(UnicodeScalar)](#matchChar)**
* **[match(String)](#matchString)**
* **[reset()](#reset)**
* **[peekAtEnd()](#peekAtEnd)**
* **[skip(length: Int)](#skipLength)**
* **[back(length: Int)](#backLength)**

Other
-------
* **[Installation](#installation)**
* **[Tests](#tests)**
* **[Requirements](#requirements)**
* **[Credits](#credits)**

### `scan` functions

<a name="scanChar" />
#### `func scanChar() throws -> UnicodeScalar`
`scanChar` allows you to scan the next character after the current's scanner `position` and return it as `UnicodeScalar`.
If operation succeded internal scanner's `position` is advanced by 1 character (as unicode).
If operation fails an exception is thrown.

Example:
```swift
let scanner = StringScanner("Hello this is SwiftScanner")
let firstChar = try! scanner.scanChar() // get 'H'
```

<a name="scanInt" />
#### `func scanInt() throws -> Int`
Scan the next integer value after the current scanner's `position`; consume scalars from {0...9} until a non numeric value is encountered. Return the integer representation in base 10.
Throw `.invalidInt` if scalar at current position is not in allowed range (may also return `.eof`).
If operation succeded internal scanner's `position` is advanced by the number of character which represent an integer.
If operation fails an exception is thrown.

Example:
```swift
let scanner = StringScanner("15 apples")
let parsedInt = try! scanner.scanInt() // get Int=15
```

<a name="scanFloat" />
#### `func scanFloat() throws -> Float`
Scan for a float value (in format ##.##) and convert it to a valid Floast.
If scan succeded scanner's `position` is updated at the end of the represented string, otherwise an exception (`.invalidFloat`, `.eof`) is thrown and index is not touched.

Example:
```swift
let scanner = StringScanner("45.54 $")
let parsedFloat = try! scanner.scanFloat() // get Int=45.54
```

<a name="scanHexInt" />
#### `func scanHexInt(digits: BitDigits) throws -> Int`
Scan an HEX digit expressed in these formats:

* `0x[VALUE]` (example: `0x0000000000564534`)
* `0X[VALUE]` (example: `0x0929`)
* `#[VALUE]` (example: `#1602`)

If scan succeded scanner's `position` is updated at the end of the represented string, otherwise an exception ((`.notFound`, )`.invalidHex`, `.eof`) is thrown and index is not touched.

Example:
```swift
let scanner = StringScanner("#1602")
let value = try! scanner.scanHexInt(.bit16) // get Int=5634

let scanner = StringScanner("#0x0929")
let value = try! scanner.scanHexInt(.bit16) // get Int=2345

let scanner = StringScanner("#0x0000000000564534")
let value = try! scanner.scanHexInt(.bit64) // get Int=5653812
```
<a name="scanUpToChar" />
#### `public func scan(upTo char: UnicodeScalar) throws -> String?`
Scan until given character is found starting from current scanner `position` till the end of the source string.
Scanner's `position` is updated only if character is found and set just before it.
Throw an exception if `.eof` is reached or `.notFound` if char was not found (in this case scanner's position is not updated)

Example:
```swift
let scanner = StringScanner("Hello <bold>Daniele</bold>")
let partialString = try! scanner.scan(upTo: "<bold>") // get "Hello "
```

<a name="scanUpToCharset" />
#### `func scan(upTo charSet: CharacterSet) throws -> String?`
Scan until given character's is found.
Index is reported before the start of the sequence, scanner's `position` is updated only if sequence is found.
Throw an exception if `.eof` is reached or `.notFound` if sequence was not found.

Example:
```swift
let scanner = StringScanner("Hello, I've at least 15 apples")
let partialString = try! scanner.scan(upTo: CharacterSet.decimalDigits) // get "Hello, I've at least "
```

<a name="scanUntilInCharset" />
#### `func scan(untilIn charSet: CharacterSet) throws -> String?`
Scan, starting from scanner's `position` until the next character of the scanner is contained into given character set.
Scanner's `position` is updated automatically at the end of the sequence if validated, otherwise it will not touched.

Example:
```swift
let scanner = StringScanner("HELLO i'm mark")
let partialString = try! scanner.scan(untilIn: CharacterSet.lowercaseLetters) // get "HELLO"
```

<a name="scanUpToString" />
#### `func scan(upTo string: String) throws -> String?`
Scan, starting from scanner's `position`  until specified string is encountered.
Scanner's `position` is updated automatically at the end of the sequence if validated, otherwise it will not touched.

Example:
```swift
let scanner = StringScanner("This is a simple test I've made")
let partialString = try! scanner.scan(upTo: "I've") // get "This is a simple test "
```

<a name="scanUntilTrue" />
#### `func scan(untilTrue test: ((UnicodeScalar) -> (Bool))) -> String`
Scan and consume at the scalar starting from current `position`, testing it with function test.
If test returns `true`, the `position` increased.
If `false`, the function returns.

Example:
```swift
let scanner = StringScanner("Never be satisfied 💪 and always push yourself! 😎 Do the things people say cannot be done")
let delimiters = CharacterSet(charactersIn: "💪😎")
while !scanner.isAtEnd {
  let block = scanner.scan(untilTrue: { char in
    return (delimiters.contains(char) == false)
  })
  // Print:
  // "Never be satisfied " (first iteration)
  // "and always push yourself!" (second iteration)
  // "Do the things people say cannot be done" (third iteration)
  print("Block: \(block)")
	try scanner.skip() // push over the character
}
```

<a name="scanLenght" />
#### `func scan(length: Int=1) -> String`
Read next length characters and accumulate it
If operation is succeded scanner's `position` are updated according to consumed scalars.
If fails an exception is thrown and `position` is not updated.

Example:
```swift
let scanner = StringScanner("Never be satisfied")
let partialString = scanner.scan(5) // "Never"
```
### `peek` functions

Peek functions are the same as concept of `scan()` but unless it it does not update internal scanner's `position` index.
These functions usually return only `starting index` of matched pattern.

<a name="peekUpToChar" />
#### `func peek(upTo char: UnicodeScalar) -> String.UnicodeScalarView.Index`
Peek until chracter is found starting from current scanner's `position`.
Scanner's `position` is never updated.
Throw an exception if `.eof` is reached or `.notFound` if char was not found.

Example:
```swift
let scanner = StringScanner("Never be satisfied")
let index = try! scanner.peek(upTo: "b") // return 6
```

<a name="peekUpToCharset" />
#### `func peek(upTo charSet: CharacterSet) -> String.UnicodeScalarView.Index`
Peek until one the characters specified by set is encountered
Index is reported before the start of the sequence, but scanner's `position` is never updated.
Throw an exception if .eof is reached or .notFound if sequence was not found

Example:
```swift
let scanner = StringScanner("You are in queue: 123 is your position")
let index = try! scanner.peek(upTo: CharacterSet.decimalDigits) // return 18
```

<a name="peekUpUntilInCharset" />
#### `func peek(untilIn charSet: CharacterSet) -> String.UnicodeScalarView.Index`
Peek until the next character of the scanner is contained into given.
Scanner's `position` is never updated.

Example:
```swift
let scanner = StringScanner("654 apples")
let index = try! scanner.peek(untilIn: CharacterSet.decimalDigits) // return 3
```

<a name="peekUpToString" />
#### `func peek(upTo string: String) -> String.UnicodeScalarView.Index`
Iterate until specified string is encountered without updating indexes.
Scanner's `position` is never updated but it's reported the index just before found occourence.

Example:
```swift
let scanner = StringScanner("654 apples in the bug")
let index = try! scanner.peek(upTo: "in") // return 11
```

<a name="peekUpUntil" />
#### `func peek(untilTrue test: ((UnicodeScalar) -> (Bool))) -> String.UnicodeScalarView.Index`
Peeks at the scalar at the current position, testing it with function test.
It only peeks so current scanner's `position` is not increased at the end of the operation

Example:
```swift
let scanner = StringScanner("I'm very 💪 and 😎 Go!")
let delimiters = CharacterSet(charactersIn: "💪😎")
while !scanner.isAtEnd {
  let prevIndex = scanner.position
  let finalIndex = scanner.peek(untilTrue: { char in
    return (delimiters.contains(char) == false)
	})
  // Distance will return:
  // - 9 (first iteration)
  // - 5 (second iteration)
  // - 4 (third iteration)
	let distance = scanner.string.distance(from: prevIndex, to: finalIndex)
	try scanner.skip(length: distance + 1)
}
```
### Other Functions

<a name="matchChar" />
#### `func match(_ char: UnicodeScalar) -> Bool`
Return false if the scalar at the current position don't match given scalar.
Advance scanner's `position` to the end of the match if match.

```swift
let scanner = StringScanner("💪 and 😎")
let match = scanner.match("😎") // return false
```

<a name="matchString" />
#### `func match(_ match: String) -> Bool`
Return false if scalars starting at the current position don't match scalars in given string.
Advance scanner's `position` to the end of the match string if match.

```swift
let scanner = StringScanner("I'm very 💪 and 😎 Go!")
scanner.match("I'm very") // return true
```

<a name="reset" />
#### `func reset()`
Move scanner's internal `position` to the start of the string.

<a name="peekAtEnd" />
#### `func peekAtEnd()`
Move to the index's end index.

<a name="skipLength" />
#### `func skip(length: Int = 1) throws`
Attempt to advance scanner's  by length
If operation is not possible (reached the end of the string) it throws and current scanner's `position` of the index did not change
If operation succeded scanner's `position` is updated.

<a name="backLength" />
#### `func back(length: Int = 1) throws`
Attempt to advance the position back by length
If operation fails scanner's `position` is not touched
If operation succeded scaner's `position` is modified according to new value

<a name="installation" />
## Installation
You can install Swiftline using CocoaPods, carthage and Swift package manager

### CocoaPods
    use_frameworks!
    pod 'SwiftScanner'

### Carthage
    github 'malcommac/SwiftScanner'

### Swift Package Manager
Add swiftline as dependency in your `Package.swift`

```
  import PackageDescription

  let package = Package(name: "YourPackage",
    dependencies: [
      .Package(url: "https://github.com/malcommac/SwiftScanner.git", majorVersion: 0),
    ]
  )
```

<a name="tests" />
## Tests
Tests can be found [here](https://github.com/malcommac/SwiftScanner/tree/master/Tests). 

Run them with 
```
swift test
```

<a name="requirements" />
## Requirements

Current version is compatible with:

* **Swift 4.x** >= 1.0.4
* **Swift 3.x**: up to 1.0.3

* iOS 8 or later
* macOS 10.10 or later
* watchOS 2.0 or later
* tvOS 9.0 or later
* ...and virtually any platform which is compatible with Swift 3 and implements the Swift Foundation Library


<a name="credits" />
## Credits & License
SwiftScanner is owned and maintained by [Daniele Margutti](http://www.danielemargutti.com/).

As open source creation any help is welcome!

The code of this library is licensed under MIT License; you can use it in commercial products without any limitation.

The only requirement is to add a line in your Credits/About section with the text below:

```
Portions SwiftScanner - http://github.com/malcommac/SwiftScanner
Created by Daniele Margutti and licensed under MIT License.
```
