//
//  Default Decoders.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/29/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

/// A type that can be decoded from a NI-VISA ASCII message.
public protocol VISADecodable {
	/// The default decoder to use when decoding.
	associatedtype DefaultVISADecoder: DefaultableVISADecoder where DefaultVISADecoder.DecodingType == Self
}

// MARK: Decoding
extension VISADecodable {
	/// Decodes the NI-VISA ASCII message using the given decoder.
	///
	/// - Parameters:
	///   - string: The ASCII message to decode.
	///   - decoder: The decoder to use.
	/// - Returns: The decoded value.
	/// - Throws: If the value could not be decoded.
	public func decode<D: VISADecoder>(visaString string: String, with decoder: D) throws -> Self where D.DecodingType == Self {
		return try decoder.decode(string)
	}
	
	/// Decodes the NI-VISA ASCII message using the default decoder for this type.
	///
	/// - Parameter string: The ASCII message to decode.
	/// - Returns: The decoded value.
	/// - Throws: If the value could not be decoded.
	public func decode(visaString string: String) throws -> Self {
		let decoder = DefaultVISADecoder()
		return try decode(visaString: string, with: decoder)
	}
	
	/// Creates a new value by decoding a NI-VISA ASCII message using the given decoder.
	///
	/// - Parameters:
	/// 	- string: The ASCII message to decode.
	///		- decoder: The decoder to use.
	/// - Returns: The decoded value.
	/// - Throws: If the value could not be decoded.b
	public init<D: VISADecoder>(visaString string: String, decoder: D) throws where D.DecodingType == Self {
		self = try decoder.decode(string)
	}
	
	/// Creates a new value by decoding a NI-VISA ASCCI message using the default decoder.
	///
	/// - Parameter string: The ASCII message to decode.
	/// - Throws: If the value could not be decoded.
	public init(visaString string: String) throws {
		let decoder = DefaultVISADecoder()
		try self.init(visaString: string, decoder: decoder)
	}
}


/// A type that can decode a NI-VISA ASCII message into a decoding type.
public protocol VISADecoder {
	/// The type that the decoder decodes values to.
	associatedtype DecodingType: VISADecodable
	/// Decodes the given NI-VISA ASCII message.
	///
	/// - Parameter string: The NI-VISA ASCII message to decode.
	/// - Returns: The decoded value.
	/// - Throws: If the value could not be decoded.
	func decode(_ string: String) throws -> DecodingType
}

// TODO: This protocol can be removed and changed into a requirement for the Decodable protocol.
/// A type that can be a defualt decoder for a `Decodable` type.
public protocol DefaultableVISADecoder: VISADecoder {
	/// Creates the default decoder.
	init()
}

// MARK: String
/// The default `VISADecoder` for `String`.
///
/// This decoder simply returns the ASCII message as a `String`.
public struct DefaultVISAStringDecoder: DefaultableVISADecoder {
	public typealias DecodingType = String
	
	/// Decodes the NI-VISA ASCII message into a `String`.
	///
	/// - Parameter string: The ASCII message returned from the instrument.
	/// - Returns: The unaltered ASCII message returned from the instrument.
	public func decode(_ string: String) -> String {
		return string
	}
	
	public init() {
		// Do nothing
	}
}

extension String: VISADecodable {
	public typealias DefaultVISADecoder = DefaultVISAStringDecoder
}

// MARK: Int
/// The default `VISADecoder` for `Int`.
///
/// This decoder tries to convert the ASCII message into an integer.
public struct DefaultVISAIntDecoder: DefaultableVISADecoder {
	public typealias DecodingType = Int
	
	/// Decodes the NI-VISA ASCII message into an `Int`.
	///
	/// - Parameter string: The ASCII message returned from the instrument.
	/// - Returns: The message converted to an integer.
	/// - Throws: If the message could not be converted to an integer.
	public func decode(_ string: String) throws -> Int {
		let strippedString = string.filter { !$0.isWhitespace }
		guard let value = Int(strippedString) else { throw VISAError.couldNotDecode }
		return value
	}
	
	public init() {
		
	}
}

extension Int: VISADecodable {
	public typealias DefaultVISADecoder = DefaultVISAIntDecoder
}

// MARK: Double
/// The default `VISADecoder` for `Double`.
///
/// This decoder tries to convert the ASCII message into a floating-point number.
public struct DefaultVISADoubleDecoder: DefaultableVISADecoder {
	public typealias DecodingType = Double
	
	/// Decodes the NI-VISA ASCII message into a `Double`.
	///
	/// - Parameter string: The ASCII message returned from the instrument.
	/// - Returns: The message converted to a floating-point number.
	/// - Throws: If the message could not be converted to a floating-point-number.
	public func decode(_ string: String) throws -> Double {
		let strippedString = string.filter { !$0.isWhitespace }
		
		guard let value = Double(strippedString) else { throw VISAError.couldNotDecode }
		return value
	}
	
	public init() {
		
	}
}

extension Double: VISADecodable {
	public typealias DefaultVISADecoder = DefaultVISADoubleDecoder
}

// MARK: Bool
/// The default `VISADecoder` for `Bool`.
///
/// This decoder tries to convert the ASCII message into a boolean.
public struct DefaultVISABoolDecoder: DefaultableVISADecoder {
	public typealias DecodingType = Bool
	
	/// Decodes the NI-VISA ASCII message into a `Bool`.
	///
	/// - Parameter string: The ASCII message returned from the instrument.
	/// - Returns: The message converted to a boolean.
	/// - Throws: If the message could not be converted to a boolean.
	public func decode(_ string: String) throws -> Bool {
		#warning("Not implemented")
		fatalError("Not implemented")
	}
	
	public init() {
		
	}
}

extension Bool: VISADecodable {
	public typealias DefaultVISADecoder = DefaultVISABoolDecoder
}

// MARK: Optional
/// The default `VISADecoder` for `Optional<T>`.
///
/// This supports any type `T?` where `T` conforms to `VISADecodable`.
///
/// This decoder tries to convert the ASCII message into an optional.
public struct DefaultVISAOptionalDecoder<W: VISADecodable>: DefaultableVISADecoder {
	public typealias DecodingType = W?
	
	/// Decodes the NI-VISA ASCII message into an optional.
	///
	/// - Parameter string: The ASCII message returned from the instrument.
	/// - Returns: The message converted to an optional.
	/// - Throws: If the message could not be converted to an optional.
	public func decode(_ string: String) throws -> W? {
		// FIXME: Replace this with the actual keyword for NULL in the string protocol
		if string == "NULL" {
			return nil
		}
		let decoder = W.DefaultVISADecoder()
		return try decoder.decode(string)
	}
	
	public init() {
		
	}
}

extension Optional: VISADecodable where Wrapped: VISADecodable {
	public typealias DefaultVISADecoder = DefaultVISAOptionalDecoder<Wrapped>
}
