//
//  File.swift
//  
//
//  Created by Tallak Lindseth von der Lippe on 05/12/2021.
//

import Foundation

public protocol YoloDecoder {
    func decode<T : Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoder: YoloDecoder {}
extension PropertyListDecoder: YoloDecoder {}

public struct YoloJsonConfig {
    ///The decoder used in the package.
    ///Change this property to use your own decoders, PropertyListDecoder, or configure the a JSONDecoder.
    public static var decoder: YoloDecoder = JSONDecoder()
    
    private init() {}
}
