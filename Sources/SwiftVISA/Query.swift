//
//  File.swift
//  
//
//  Created by Connor Barnes on 10/21/20.
//

import CoreSwiftVISA
import Foundation

extension MessageBasedInstrument {
	func read<T, D: StringDecoder>(
		as: T.Type,
		using decoder: D
	) throws -> T where D.DecodingType == T {
		let string = try read()
		return try decoder.decode(string)
	}
	
	func read<T: StringDecodable>(
		as type: T.Type
	) throws -> T {
		return try read(as: type,
										using: T.defaultStringDecoder)
	}
	
	func readBytes<T, D: DataDecoder>(
		length: Int,
		as type: T.Type,
		using decoder: D
	) throws -> T where D.DecodingType == T {
		let data = try readBytes(length: length)
		return try decoder.decode(data)
	}
	
	func readBytes<T: DataDecodable>(
		length: Int,
		as type: T.Type
	) throws -> T {
		return try readBytes(length: length,
												 as: type,
												 using: T.defaultDataDecoder)
	}
	
	func readBytes<T, D: DataDecoder>(
		maxLength: Int? = nil,
		as type: T.Type,
		using decoder: D
	) throws -> T where D.DecodingType == T {
		let data = try readBytes(maxLength: maxLength)
		return try decoder.decode(data)
	}
	
	func readBytes<T: DataDecodable>(
		maxLength: Int? = nil,
		as type: T.Type
	) throws -> T {
		return try readBytes(maxLength: maxLength,
												 as: type,
												 using: T.defaultDataDecoder)
	}
	
	func query<T, D: StringDecoder>(
		_ string: String,
		as type: T.Type,
		using decoder: D
	) throws -> T where D.DecodingType == T {
		try write(string)
		return try read(as: type, using: decoder)
	}
	
	func query<T: StringDecodable>(
		_ string: String,
		as type: T.Type
	) throws -> T {
		return try query(string,
										 as: type,
										 using: T.defaultStringDecoder)
	}
	
	func queryBytes<T, D: DataDecoder>(
		_ bytes: Data,
		length: Int,
		as type: T.Type,
		using decoder: D
	) throws -> T where D.DecodingType == T {
		try writeBytes(bytes)
		return try readBytes(length: length,
												 as: type,
												 using: decoder)
	}
	
	func queryBytes<T: DataDecodable>(
		_ bytes: Data,
		length: Int,
		as type: T.Type
	) throws -> T {
		return try queryBytes(bytes,
													length: length,
													as: type,
													using: T.defaultDataDecoder)
	}
	
	func queryBytes<T, D: DataDecoder>(
		_ bytes: Data,
		maxLength: Int? = nil,
		as type: T.Type,
		using decoder: D
	) throws -> T where D.DecodingType == T {
		try writeBytes(bytes)
		return try readBytes(maxLength: maxLength,
												 as: type,
												 using: decoder)
	}
	
	func queryBytes<T: DataDecodable>(
		_ bytes: Data,
		maxLength: Int? = nil,
		as type: T.Type
	) throws -> T {
		return try queryBytes(bytes,
													maxLength: maxLength,
													as: type,
													using: T.defaultDataDecoder)
	}
}
