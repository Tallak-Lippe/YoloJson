//
//  File.swift
//  
//
//  Created by Tallak Lindseth von der Lippe on 24/06/2021.
//

import Foundation

enum JSONError: Error {
    case decodingError(String)
    case castingError(String)
    case indexOutOfRange(String)
    case keyNotPresent(String)
    case other(String)
}


public extension Decodable {
    
    
    ///Returns the current value as the given type if possible.
    ///If the current value is Data, it will be decoded, and not directly casted.
    ///
    ///Will throw an error if the value is the wrong type, or if it can't be decoded.
    func cast<T: Decodable>(to type: T.Type) throws -> T  {
        if let data = self as? Data {
            do {
                return try YoloJsonConfig.decoder.decode(type, from: data)
            } catch {
                throw JSONError.decodingError("Couldn't decode data into a \(type), Data: \n\(String(data: data, encoding: .utf8) ?? "nil")\n JSONDecoder Description: \n\(error.localizedDescription)")
            }
        } else {
            guard let result = try unwrapJsonAny(self) as? T else {
                throw JSONError.castingError("Tried to unwrap value of type \(Swift.type(of: try unwrapJsonAny(self))) as \(type).")
            }
            return result
        }
    }
    
    ///Acces as an array
    ///
    ///Will throw an error if this objects isn't an array,  if the array can't be decoded or if the index is out of range
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
    ///Will throw an error if this object isn't a dictionary, if the dictionary can't be decoded or if the key isn't present i the dictionary
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
