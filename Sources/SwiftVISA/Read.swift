//
//  Read.swift
//  
//
//  Created by Connor Barnes on 11/17/20.
//

extension MessageBasedInstrument {
	/// Reads a message from the instrument and decodes it to the specified type using the provided decoder.
	/// - Parameters:
	///   - type: The type to decode the message to.
	///   - decoder: The decoder to use to decode the message.
	/// - Throws: If the message could not be read from the instrument, or if the message could not be decoded.
	/// - Returns: The decoded value.
	func read<T, D: MessageDecoder>(
		as type: T.Type,
		using decoder: D
	) throws -> T where D.DecodingType == T {
		let string = try read()
		return try decoder.decode(string)
	}
	
	/// Reads a message from the instrument and decodes it to the specified type using the type's default decoder.
	/// - Parameter type: The type to decode the message to.
	/// - Throws: If the message could not be read from the instrument, or if the messag could not be decoded.
	/// - Returns: The decoded value.
	func read<T: MessageDecodable>(
		as type: T.Type
	) throws -> T {
		return try read(as: type,
										using: T.defaultMessageDecoder)
	}
	/// Reads a number of bytes from the instrument and decodes it to the specified type using the type's default decoder.
	/// - Parameters:
	///   - length: The number of bytes to read from the instrument.
	///   - type: The type to decode the message to.
	///   - decoder: The decoder to use to decode the message.
	/// - Throws: If the message could not be read from the instrument, or if the message could not be decoded.
	/// - Returns: The decoded value.
	func readBytes<T, D: ByteDecoder>(
		length: Int,
		as type: T.Type,
		using decoder: D
	) throws -> T where D.DecodingType == T {
		let data = try readBytes(length: length)
		return try decoder.decode(data)
	}
	/// Reads a number of bytes from the instrument and decodes it to the specified type using the type's default decoder.
	/// - Parameters:
	///   - length: The number of bytes to read from the instrument.
	///   - type: The type to decode the message to.
	/// - Throws: If the message could not be read from the instrument, or if the message could not be decoded.
	/// - Returns: The decoded value.
	func readBytes<T: ByteDecodable>(
		length: Int,
		as type: T.Type
	) throws -> T {
		return try readBytes(length: length,
												 as: type,
												 using: T.defaultByteDecoder)
	}
	/// Reads a sequence of bytes from the instrument and decodes it to the specified type using the type's default decoder.
	/// - Parameters:
	///   - maxLength: The maximum number of bytes to read.
	///   - type: The type to decode the message to.
	///   - decoder: The decoder to use to decode the message.
	/// - Throws: If the message could not be read from the instrument, or if the message could not be decoded.
	/// - Returns: The decoded value.
	func readBytes<T, D: ByteDecoder>(
		maxLength: Int? = nil,
		as type: T.Type,
		using decoder: D
	) throws -> T where D.DecodingType == T {
		let data = try readBytes(maxLength: maxLength)
		return try decoder.decode(data)
	}
	/// Reads a sequence of bytes from the instrument and decodes it to the specified type using the type's default decoder.
	/// - Parameters:
	///   - maxLength: The maximum number or bytes to read.
	///   - type: The type to decode the message to.
	/// - Throws: If the message could not be read from the instrument, or if the message could not be decoded.
	/// - Returns: The decoded value.
	func readBytes<T: ByteDecodable>(
		maxLength: Int? = nil,
		as type: T.Type
	) throws -> T {
		return try readBytes(maxLength: maxLength,
												 as: type,
												 using: T.defaultByteDecoder)
	}
}


