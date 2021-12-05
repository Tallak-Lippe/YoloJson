//
//  File.swift
//  
//
//  Created by Tallak Lindseth von der Lippe on 05/12/2021.
//

import Foundation

public extension Decodable {
    ///Returns a copy of self casted as a Decodable array
    ///
    ///The main use of this would be to access convenient array functions as map, filter and reduce as well as to be able to loop over the elements.
    ///You can continue using this library inside a loop or any array functions like this:
    ///````
    ///let allIDs: [String] = try data["_embedded"]["recommendations"].array.map {
    ///    $0["series"]["id"] as! String
    ///}
    ///````
    ///This will throw an error if the data can't be decoded or if the object isn't an array
    ///If the array contains arrays or dictionaries, these will be wrapped in a JSONAny. These will be unwrapped if handled by this api.
    var array: [Decodable] {
        get throws {
            try cast(to: [JSONAny].self)
        }
        
    }
    
    ///Returns a copy of self casted as a Decodable dictionary with String keys
    ///
    ///The main use of this would be to access convenient dictionary functions as mapValues as well as to be able to loop over the elements.
    ///This will throw an error if the data can't be decoded or the object isn't a Dictionary.
    ///If the dictionary contains dictionaries or arrays, these will be wrapped in a JSONAny. These will be unwrapped if handled by this api.
    var dictionary: [String : Decodable] {
        get throws {
            try cast(to: [String : JSONAny].self)
        }
    }
    
    ///Shortcut for cast(to: String.self)
    var string: String {
        get throws {
            try cast(to: String.self)
        }
    }
    
    ///Shortcut for cast(to: Double.self)
    var double: Double {
        get throws {
            try cast(to: Double.self)
        }
    }
    
    ///Shortcut for cast(to: Int.self)
    var int: Int {
        get throws {
            try cast(to: Int.self)
        }
    }
}
