//
//  Query.swift
//  
//
//  Created by Connor Barnes on 10/21/20.
//

import Foundation

extension MessageBasedInstrument {
	/// Writes a string to the instrument, then reads back the response from the instrument.
	/// - Parameter string: The string to write to the instrument.
	/// - Throws: If the insturment could not be written to or read from.
	/// - Returns: The instrument's response.
	func query(_ string: String) throws -> String {
		try write(string)
		return try read()
	}
	/// Writes a string to the instrument, then reads back the response from the instrument and decodes it to the specified type using the given decoder.
	/// - Parameters:
	///   - string: The string to write to the instrument.
	///   - type: The type to decode the response to.
	///   - decoder: The decoder to use to decode the response.
	/// - Throws: If the instrument could not be written to or read from, or if the response could not be decoded.
	/// - Returns: The decoded instrument's response.
	func query<T, D: MessageDecoder>(
		_ string: String,
		as type: T.Type,
		using decoder: D
	) throws -> T where D.DecodingType == T {
		try write(string)
		return try read(as: type, using: decoder)
	}
	/// Writes a string to the instrument, then reads back the response from the instrument and decodes it to the specified type using the type's defualt decoder.
	/// - Parameters:
	///   - string: The string to write to the instrument.
	///   - type: The type to decode the response to.
	/// - Throws: If the instrument could not be written to or read from, or if the response could not be decoded.
	/// - Returns: The decoded instrument's response.
	func query<T: MessageDecodable>(
		_ string: String,
		as type: T.Type
	) throws -> T {
		return try query(string,
										 as: type,
										 using: T.defaultMessageDecoder)
	}
	/// Writes a sequence of bytes to the instrument, then reads back a number of bytes from the instrument and decodes it to the specified type using the given decoder.
	/// - Parameters:
	///   - bytes: The sequence of bytes to write to the instrument.
	///   - length: The number of bytes to read back from the instrument.
	///   - type: The type to decode the response to.
	///   - decoder: The decoder to use to decode the response.
	/// - Throws: If the instrument could not be written to or read from, or if the response could not be decoded.
	/// - Returns: The decoded instrument's response.
	func queryBytes<T, D: ByteDecoder>(
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
	/// Writes a sequence of bytes to the instrument, then reads back a number of bytes from the instrument and decodes it to the specified type using the type's default decoder.
	/// - Parameters:
	///   - bytes: The sequence of bytes to write to the instrument.
	///   - length: The number of bytes to read back from the instrument.
	///   - type: The type to decode the response to.
	/// - Throws: If the instrument could not be written to or read from, or if the response could not be decoded.
	/// - Returns: The decoded instrument's response.
	func queryBytes<T: ByteDecodable>(
		_ bytes: Data,
		length: Int,
		as type: T.Type
	) throws -> T {
		return try queryBytes(bytes,
													length: length,
													as: type,
													using: T.defaultByteDecoder)
	}
	/// Writes a sequence of bytes to the instrument, then reads back a sequence of bytes from the instrument and decodes it to the specified type using the given decoder.
	/// - Parameters:
	///   - bytes: The sequence of bytes to write to the instrument.
	///   - maxLength: The maximum number of bytes to read back from the instrument.
	///   - type: The type to decode the response to.
	///   - decoder: The decoder to use to decode the response.
	/// - Throws: If the instrument could not be written to or read from, or if the response could not be decoded.
	/// - Returns: The decoded message.
	func queryBytes<T, D: ByteDecoder>(
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
	/// Writes a sequence of bytes to the instrument, then reads back a sequence of bytes from the instrument and decodes it to the specified type using the type's default decoder.
	/// - Parameters:
	///   - bytes: The sequence of bytes to write to the instrument.
	///   - maxLength: The maximum number of bytes to read back from the instrument.
	///   - type: The type to decode the response to.
	/// - Throws: If the instrument could not be written to or read from, or if the response could not be decoded.
	/// - Returns: The decoded message.
	func queryBytes<T: ByteDecodable>(
		_ bytes: Data,
		maxLength: Int? = nil,
		as type: T.Type
	) throws -> T {
		return try queryBytes(bytes,
													maxLength: maxLength,
													as: type,
													using: T.defaultByteDecoder)
	}
}
