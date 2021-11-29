# YoloJson

YoloJson makes scripting with JSON much easier. It is perfect for getting only a few values from an api without recreating the whole json structure. You simply write the path to the value  you want and cast the it like this:

```swift

let data = //Some networking code

let ID = try data["_embedded"]["recommendations"][0]["series"]["id"] as! String
```
You can also access whole arrays and dictionaries to use powerful functions like map, filter and reduce like this:

```swift
let allIDs: [String] = try data["_embedded"]["recommendations"].array.map {
    $0["series"]["id"] as! String
}
```

Using this api will throw an error under a few circumstances:
* The data can't be decoded by swift's JSONDecoder
* Data that isn't an array is accessed like an array with "subscript(index: Int)"
* Data that isn't a dictionary is accessed like a dictionary "subscript(key: String)"
* Index out of range in array access
* Key not present in dictionary under dictionary access

Please let me know @TallakLippe on twitter or create a PR if there is anything I can / should improve. I will work on some more descriptive error-messages soon.

The examples here are made and tested with json data from NRK.
