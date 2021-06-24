# YoloJson

YoloJson makes scripting with json much easier. It is perfect for getting only a few values from an api without recreating the whole json structure. You simply write the path to the value  you want and cast the it like this:

```swift

let data = //Some networking code

let ID = data["_embedded"]["recommendations"][0]["series"]["id"] as! String
```
You can also access whole arrays and dictionaries to use powerful functions like map, filter and reduce like this:

```swift
let allIDs: [String] = data["_embedded"]["recommendations"].array.map {
    $0["series"]["id"] as! String
}
```

But be careful! There are no error- handling in this framework so you have to be sure your paths and json data is correct. This framework is mainly meant for scripting and prototyping.

Please let me know @TallakLippe on twitter or create a PR if there is anything I can / should improve. I will work on some more descriptive error-messages soon.

The examples here are made and tested with json data from NRK.
