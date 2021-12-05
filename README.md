# YoloJson

YoloJson makes scripting with JSON much easier. It is perfect for getting only a few values from an api without recreating the whole json structure. You simply write the path to the value you want and cast the it like this:

```swift
let data = //Some networking code

let ID = try data["_embedded"]["recommendations"][0]["series"]["id"].cast(to: String.self)
```
## Installation
### Swift package manager
You can install YoloJson via the [Swift Package Manager](https://swift.org/package-manager/). This package doesn't have any dependencies so only one package will be installed.


## Usage
Use the two subscripts for arrays and dictionaries to chain together the path to the object you wan't. The framework will do all the casting and decoding to the correct data types for you.
```swift
try data["_embedded"]["recommendations"][0]["series"]["id"]
```
Then cast the object to the type you wan't and store it in a variable
```swift
let ID = try data["_embedded"]["recommendations"][0]["series"]["id"].cast(to: String.self)
```
You can also access whole arrays and dictionaries to use powerful functions like map, filter and reduce like this:
```swift
let allIDs: [String] = try data["_embedded"]["recommendations"].array.flatMap {
    try? $0["series"]["id"].cast(to: String.self)
}
```

### Errors
Using this api will throw an error under a few circumstances:
* The data can't be decoded by swift's JSONDecoder
* Data that isn't an array is accessed like an array with "subscript(index: Int)"
* Data that isn't a dictionary is accessed like a dictionary "subscript(key: String)"
* Index out of range in array access
* Key not present in dictionary under dictionary access

I am open for PRs and comments with suggestions and improvements

