//
//  Default Decoders.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/29/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

/// A Direct Edit by Owen

/// A type that can be decoded from a NI-VISA ASCII message.
public protocol VISADecodable {
	/// The default decoder type to use when decoding.
	associatedtype DefaultVISADecoder: VISADecoder where DefaultVISADecoder.DecodingType == Self
	/// The defualt decoder to use when decoding.
	static var defaultVISADecoder: DefaultVISADecoder { get }
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
		let decoder = Self.defaultVISADecoder
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
		let decoder = Self.defaultVISADecoder
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

// MARK: String
/// The default `VISADecoder` for `String`.
///
/// This decoder simply returns the ASCII message as a `String`.
public struct DefaultVISAStringDecoder: VISADecoder {
	public var shouldStripNewline: Bool
	
	/// Decodes the NI-VISA ASCII message into a `String`.
	///
	/// - Parameter string: The ASCII message returned from the instrument.
	/// - Returns: The unaltered ASCII message returned from the instrument.
	public func decode(_ string: String) -> String {
		if shouldStripNewline && string.hasSuffix("\n") {
			return String(string.dropLast())
		} else {
			return string
		}
	}
	
	init(shouldStripNewline: Bool = false) {
		self.shouldStripNewline = shouldStripNewline
	}
}

extension String: VISADecodable {
	public static var defaultVISADecoder: DefaultVISAStringDecoder {
		return DefaultVISAStringDecoder()
	}
}

// MARK: Int
/// The default `VISADecoder` for `Int`.
///
/// This decoder tries to convert the ASCII message into an integer.
public struct DefaultVISAIntDecoder: VISADecoder {
	/// Decodes the NI-VISA ASCII message into an `Int`.
	///
	/// - Parameter string: The ASCII message returned from the instrument.
	/// - Returns: The message converted to an integer.
	/// - Throws: If the message could not be converted to an integer.
	public func decode(_ string: String) throws -> Int {
		let strippedString = string.filter { !$0.isWhitespace }
		if let value = Int(strippedString) {
			// The value was an integer, return it
			return value
		} else if let doubleValue = Double(strippedString) {
			// The value was a double, floor it, then return it
			if doubleValue > Double(Int.min) && doubleValue < Double(Int.max) {
				return Int(doubleValue)
			} else {
				throw VISAError.couldNotDecode
			}
		} else { throw VISAError.couldNotDecode }
	}
}

extension Int: VISADecodable {
	public static var defaultVISADecoder: DefaultVISAIntDecoder {
		return DefaultVISAIntDecoder()
	}
}

// MARK: Double
/// The default `VISADecoder` for `Double`.
///
/// This decoder tries to convert the ASCII message into a floating-point number.
public struct DefaultVISADoubleDecoder: VISADecoder {
	/// Decodes the NI-VISA ASCII message into a `Double`.
	///
	/// - Parameter string: The ASCII message returned from the instrument.
	/// - Returns: The message converted to a floating-point number.
	/// - Throws: If the message could not be converted to a floating-point-number.
	public func decode(_ string: String) throws -> Double {
		let strippedString = string.filter { !$0.isWhitespace }
		
		switch strippedString {
		case "INF":
			return .infinity
		case "NINF":
			return -.infinity
		case "NAN":
			return .nan
		default:
			guard let value = Double(strippedString) else { throw VISAError.couldNotDecode }
			
			let tolerance = 9.9e37 / 1000.0
			
			if abs(value - 9.9e37) < tolerance {
				// SCPI syntax defines 9.9e37 to be infinity
				return .infinity
			} else if abs(value + 9.9e37) < tolerance {
				// SCPI syntax defines -9.9e37 to be negative infinity
				return -.infinity
			} else if abs(value + 9.91e37) < tolerance {
				// SCPI syntax defines 9.91e37 to be not a number
				return .nan
			} else {
				return value
			}
		}
	}
}

extension Double: VISADecodable {
	public static var defaultVISADecoder: DefaultVISADoubleDecoder {
		return DefaultVISADoubleDecoder()
	}
}

// MARK: Bool
/// The default `VISADecoder` for `Bool`.
///
/// This decoder tries to convert the ASCII message into a boolean.
public struct DefaultVISABoolDecoder: VISADecoder {
	/// Decodes the NI-VISA ASCII message into a `Bool`.
	///
	/// - Parameter string: The ASCII message returned from the instrument.
	/// - Returns: The message converted to a boolean.
	/// - Throws: If the message could not be converted to a boolean.
	public func decode(_ string: String) throws -> Bool {
		let strippedString = string.filter { !$0.isWhitespace }
		
		switch strippedString {
		case "0", "OFF":
			return false
		case "1", "ON":
			return true
		default:
			throw VISAError.couldNotDecode
		}
	}
}

extension Bool: VISADecodable {
	public static var defaultVISADecoder: DefaultVISABoolDecoder {
		return DefaultVISABoolDecoder()
	}
}

// MARK: Data
/// The default `VISADecoder` for `Data`.
///
/// This decoder converts the ascii message into raw data.
public struct DefaultVISADataDecoder: VISADecoder {
	public var stringEncoding: String.Encoding
	public var shouldStripNewline: Bool
	
	/// Decodes the NI-VISA ASCII message into a `Bool`.
	///
	/// - Parameter string: The ASCII message returned from the instrument.
	/// - Returns: The message converted to a boolean.
	/// - Throws: If the message could not be converted to a boolean.
	public func decode(_ string: String) throws -> Data {
		let strippedString: String
		if shouldStripNewline && string.hasSuffix("\n") {
			strippedString = String(string.dropLast())
		} else {
			strippedString = string
		}
		guard let data = strippedString.data(using: .ascii) else {
			throw VISAError.couldNotDecode
		}
		return data
	}
	
	public init(stringEncoding: String.Encoding = .ascii, shouldStripNewline: Bool = false) {
		self.stringEncoding = stringEncoding
		self.shouldStripNewline = shouldStripNewline
	}
}

extension Data: VISADecodable {
	public static var defaultVISADecoder: DefaultVISADataDecoder {
		return DefaultVISADataDecoder()
	}
}

// MARK: Optional
/// The default `VISADecoder` for `Optional<T>`.
///
/// This supports any type `T?` where `T` conforms to `VISADecodable`.
///
/// This decoder tries to convert the ASCII message into an optional.
public struct DefaultVISAOptionalDecoder<W: VISADecodable>: VISADecoder {
	/// Decodes the NI-VISA ASCII message into an optional.
	///
	/// - Parameter string: The ASCII message returned from the instrument.
	/// - Returns: The message converted to an optional.
	/// - Throws: If the message could not be converted to an optional.
	public func decode(_ string: String) throws -> W? {
		if W.self == String.self {
			// If the type is decoding to string, there is no way to differentiate between an empty string and nil, so it will always return a string rather than nil.
			return try W.defaultVISADecoder.decode(string)
		}
		switch string {
		case "\n", "\r", "":
			return nil
		default:
			let decoder = W.defaultVISADecoder
			return try decoder.decode(string)
		}
	}
}

extension Optional: VISADecodable where Wrapped: VISADecodable {
	public static var defaultVISADecoder: DefaultVISAOptionalDecoder<Wrapped> {
		return DefaultVISAOptionalDecoder()
	}
}
