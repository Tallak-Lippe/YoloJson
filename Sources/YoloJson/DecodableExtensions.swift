//
//  File.swift
//  
//
//  Created by Tallak Lindseth von der Lippe on 24/06/2021.
//

import Foundation

enum JSONError: Error {
    case dictionaryDecodingError(String)
    case arrayDecodingError(String)
    case indexOutOfRange(String)
    case keyNotPresent(String)
    case other(String)
}


public extension Decodable {
    ///Returns a copy of self casted as a Decodable array
    ///
    ///The main use of this would be to access convenient array functions as map, filter and reduce as well as to be able to loop over the elements.
    ///You can continue using this library inside a loop or any array functions like this:
    ///````
    ///let allIDs: [String] = data["_embedded"]["recommendations"].array.map {
    ///    $0["series"]["id"] as! String
    ///}
    ///````
    ///Using this property will crash the application if the data can't be decoded or if self is something else then an array
    ///If the array contains arrays or dictionaries, these will be wrapped in a JSONAny. If this api is used to access these elements too, the unwrapping will be taken care of.
    var array: [Decodable] {
        get throws {
            if let data = self as? Data {
                do {
                    return try JSONDecoder().decode([JSONAny].self, from: data)
                } catch {
                    throw JSONError.arrayDecodingError("Couldn't decode data into an array, Data: \n\(String(data: data, encoding: .utf8) ?? "nil")\n JSONDecoder Description: \n\(error.localizedDescription)")
                }
            } else {
                guard let result = try unwrapJsonAny(self) as? [Decodable] else {
                    throw JSONError.arrayDecodingError("Tried to unwrap value of type \(type(of: try unwrapJsonAny(self))) as an array.")
                }
                return result
            }
        }
        
    }
    
    ///Returns a copy of self casted as a Decodable dictionary with String keys
    ///
    ///The main use of this would be to access convenient dictionary functions as mapValues as well as to be able to loop over the elements.
    ///This will crash the application if the data can't be decoded or if self is something else then a Dictionary.
    ///If the dictionary contains dictionaries or arrays, these will be wrapped in a JSONAny. If this api is used to access these elements too, the unwrapping will be taken care of.
    var dictionary: [String : Decodable] {
        get throws {
            if let data = self as? Data {
                do {
                    return try JSONDecoder().decode([String : JSONAny].self, from: data)
                } catch {
                    throw JSONError.dictionaryDecodingError("Couldn't decode data into a dictionary, Data: \n\(String(data: data, encoding: .utf8) ?? "nil")\n Description: \n\(error.localizedDescription)")
                }
                
            } else {
                guard let result = try unwrapJsonAny(self) as? [String : Decodable] else {
                    throw JSONError.dictionaryDecodingError("Tried to unwrap value of type \(type(of: try unwrapJsonAny(self))) as a dictionary.")
                }
                return result
            }
        }
    }
    
    ///Acces as an array
    ///
    ///This is one of the two major points of failure. You can get an Index out of range exception, and the application can crash because this actually isn't an array.
    subscript(index: Int) -> Decodable{
        get throws {
            let array = try array
            guard index < array.count else {
                throw JSONError.indexOutOfRange("Index is \(index), but array count is \(array.count)")
            }
            
            return try unwrapJsonAny(array[index])
        }
    }
    
    ///Acces as a dictionary.
    ///
    ///This is one of the two major points of failure. If the key passed isn't in the dictionary, or there isn't a dictionary here, the application will crash.
    subscript(index: String) -> Decodable {
        get throws {
            guard let value = try dictionary[index] else {
                throw JSONError.keyNotPresent(#"The key "\#(index)" isn't present in the dictionary. All the available keys are: \#(try! dictionary.keys)"#)
            }
            return try unwrapJsonAny(value)
        }
    }
    
    //If the value is of type JSONAny, unwrap it but make sure it is still Decodable
    private func unwrapJsonAny(_ value: Decodable) throws -> Decodable {
        //If it is JSONAny, extract the wrapped value
        if let value = (value as? JSONAny)?.value {
            //The elements of a dictionary or an array has to be wrapped in JSONAny to still be Decodable.
            if let value = value as? [String : Any] {
                return value.mapValues{ JSONAny(value: $0) }
            } else if let value = value as? [Any] {
                return value.map{ JSONAny(value : $0) }
            } else {
                //The value isn't a dictionary or an array so just return it as Decodable. You can be quite certain that this value actually is Decodable because it was able to be decoded from the start when being wrapped in the JSONAny.
                guard let value = value as? Decodable else {
                    throw JSONError.other("Couldn't cast value of type \(type(of: value)) as Decodable")
                }
                
                return value
            }
        } else {
            //The value isn't JSONAny and doesn't have to be unwrapped
            return value
        }
    }
}
