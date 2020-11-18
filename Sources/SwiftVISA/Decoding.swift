//
//  Decoding.swift
//  
//
//  Created by Connor Barnes on 10/14/20.
//

import CoreSwiftVISA
import Foundation

// MARK: String Decoding
public protocol StringDecodable {
	associatedtype DefaultStringDecoder: StringDecoder where DefaultStringDecoder.DecodingType == Self
	
	static var defaultStringDecoder: DefaultStringDecoder { get }
}

public protocol StringDecoder {
	associatedtype DecodingType
	
	func decode(_ string: String) throws -> DecodingType
}

extension StringDecodable {
	public static func decoded<D: StringDecoder>(from string: String, with decoder: D) throws -> Self where D.DecodingType == Self {
		return try decoder.decode(string)
	}
	
	public static func decoded(from string: String) throws -> Self {
		return try defaultStringDecoder.decode(string)
	}
}

// MARK: Data Decoding
public protocol DataDecodable {
	associatedtype DefaultDataDecoder: DataDecoder where DefaultDataDecoder.DecodingType == Self
	
	static var defaultDataDecoder: DefaultDataDecoder { get }
}

public protocol DataDecoder {
	associatedtype DecodingType
	
	func decode(_ data: Data) throws -> DecodingType
}



extension DataDecodable {
	public static func decoded<D: DataDecoder>(from data: Data, with decoder: D) throws -> Self where D.DecodingType == Self {
		return try decoder.decode(data)
	}
	
	public static func decoded(from data: Data) throws -> Self {
		return try defaultDataDecoder.decode(data)
	}
}
