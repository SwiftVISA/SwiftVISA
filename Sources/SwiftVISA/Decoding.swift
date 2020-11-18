//
//  Decoding.swift
//  
//
//  Created by Connor Barnes on 10/14/20.
//

import Foundation

// MARK: Message Decoding
/// A type that provides a default message decoder.
///
/// Conforming to `MessageDecodable` allows `read(as:)` and `decode(_:as:)` to be called without specifying an explicit decoder.
public protocol MessageDecodable {
	/// The type of the default message decoder this type uses.
	associatedtype DefaultMesssageDecoder: MessageDecoder where DefaultMesssageDecoder.DecodingType == Self
	/// The default message decoder used when calling `read(as:)` or `decode(_:as:)`.
	static var defaultMessageDecoder: DefaultMesssageDecoder { get }
}

/// A type that can decode a message from a VISA instrument and convert it into another type.
public protocol MessageDecoder {
	/// The type that this decoder decodes values to.
	associatedtype DecodingType
	/// Decodes a message from a VISA instrument.
	/// - Parameter message: The message to decode.
	/// - Throws: If the message could not be decoded.
	/// - Returns: The decoded value.
	func decode(_ message: String) throws -> DecodingType
}

// MARK: Byte Decoding
/// A type that provides a default byte decoder.
///
/// Conforming to `ByteDecodable` allows `readBytes(as:)` or `queryBytes(_:as:)` to be called without specifying an explicit decoder.
public protocol ByteDecodable {
	// The type of the default byte decoder this type uses.
	associatedtype DefaultByteDecoder: ByteDecoder where DefaultByteDecoder.DecodingType == Self
	/// The default byte decoder used when calling `read(as:)` or `decode(_:as:)`.
	static var defaultByteDecoder: DefaultByteDecoder { get }
}

/// A type that can decode a sequence of bytes from a VISA instrument and convert it into another type.
public protocol ByteDecoder {
	/// The type that this decoder decodes values to.
	associatedtype DecodingType
	/// Decodes a sequence of bytes from a VISA instrument.
	/// - Parameter bytes: The sequence of bytes to decode.
	func decode(_ bytes: Data) throws -> DecodingType
}

// MARK: Default String Decoder
/// The default message decoder for `String`.
///
/// By default, this decoder simply returns the message verbatim.
///
/// The default behavior can be changed by assigning a custom decoding function to the static property `customDecode`. If you would like to revert to default behavior, set `customDecode` to `nil`.
public struct DefaultStringDecoder: MessageDecoder {
	public typealias DecodingType = String
	
	/// Decodes a message from a VISA instrument as a `String`.
	///
	/// By default, simply returns the message verbatim.
	///
	/// The default behavior is overriden if the static property `customDecode` is set.
	///
	/// - Parameter message: The message to decode.
	/// - Throws: If the message could not be decoded (only if `customDecode` is set).
	/// - Returns: The message decoded.
	public func decode(_ message: String) throws -> String {
		if let customDecode = Self.customDecode {
			return try customDecode(message)
		}
		// By default, just return the raw message
		return message
	}
	/// If not `nil`, the decoder uses this function to decode strings.
	public static var customDecode: ((String) throws -> String)? = nil
}

extension String: MessageDecodable {
	public static var defaultMessageDecoder: DefaultStringDecoder {
		return DefaultStringDecoder()
	}
}

// MARK: Default Int Decoder
/// The default message decoder for `Int`.
///
/// By default, this decoder strips all whitespace. If the message begins with `0b`, `0o`, or `0x` the value will be decoded as a binary, octal, or hexadecimal value respectively. Otherwise, the number is decoded as a decimal integer. The message may contain a period, but must still be an exact integer, otherwise, `DefaultIntDecoder.Error.notAnInteger` is thrown. If the message can not be interpreted as a number, then `DefaultIntDecoder.Error.notANumber` is thrown. If a value outside of the range [`Int.min`, `Int.max`] is given, then `DefaultIntDercoder.Error.notInRange` is thrown.
///
/// The default behavior can be changed by assigning a custom decoding function to the static property `customDecode`. If you would like to revert to default behavior, set `customDecode` to `nil`.
public struct DefaultIntDecoder: MessageDecoder {
	public typealias DecodingType = Int
	/// A helper function that tries to decode a message as a binary value.
	/// - Parameter message: The message to decode after being stripped of whitespace.
	/// - Returns: The decoded value if decoding was successful, otherwise `nil`.
	private func decodeBinary(_ message: String) -> Int? {
		if message.hasPrefix("0b") {
			return Int(message.dropFirst(2), radix: 2)
		}
		return nil
	}
	/// A helper function that tries to decode a message as an octal value.
	/// - Parameter message: The message to decode after being stripped of whitespace.
	/// - Returns: The decoded value if decoding was successful, otherwise `nil`.
	private func decodeOctal(_ message: String) -> Int? {
		if message.hasPrefix("0o") {
			return Int(message.dropFirst(2), radix: 8)
		}
		return nil
	}
	/// A helper function that tries to decode a message as a hexadecimal value.
	/// - Parameter message: The message to decode after being stripped of whitespace.
	/// - Returns: The decoded value if decoding was successful, otherwise `nil`.
	private func decodeHexadecimal(_ message: String) -> Int? {
		if message.hasPrefix("0x") {
			return Int(message.dropFirst(2), radix: 16)
		}
		return nil
	}
	/// A helper function that tries to decode a message as a decimal value.
	/// - Parameter message: The message to decode after being stripped of whitespace.
	/// - Throws: `.notAnInteger` if the message was a non-integer number, `.notInRange` if an integer that was outside the range of [`Int.min`, `Int.max`] is given, or `.notANumber` if the message was not a number.
	/// - Returns: The decoded decimal integer.
	private func decodeDecimal(_ message: String) throws -> Int {
		if let value = Int(message) {
			return value
		} else if let value = Double(message) {
			if let exact = Int(exactly: value) {
				// Was a real number that was exactly an integer (which is okay)
				return exact
			}
			// Was a real number that was not exactly an integer
			// Be safe by throwing, rather than assuming and rounding
			throw Error.notAnInteger
		} else {
			let search = message.first == "-" ? message.dropFirst() : Substring(message)
			 
			if search.allSatisfy({ $0.isNumber }) && !message.isEmpty {
				 // Was an integer, but was too large / small
				 throw Error.notInRange
			 }
			 // Was not a number at all
			 throw Error.notANumber
		 }
	}
	/// Decodes a message from a VISA instrument as an `Int`.
	///
	/// By default, all whitespace is stripped. If the message begins with `0b`, `0o`, or `0x` the value will be decoded as a binary, octal, or hexadecimal value respectively. Otherwise, the number is decoded as a decimal integer. The message may contain a period, but must still be an exact integer.
	///
	/// The default behavior is overriden if the static property `customDecode` is set.
	///
	/// - Parameter message: The message to decode.
	/// - Throws: `.notAnInteger` if the message was a non-integer number, `.notInRange` if an integer that was outside the range of [`Int.min`, `Int.max`] is given, or `.notANumber` if the message was not a number.
	/// - Returns: The decoded integer.
	public func decode(_ message: String) throws -> Int {
		if let customDecode = Self.customDecode {
			return try customDecode(message)
		}
		
		let stripped = message.filter { !$0.isWhitespace }
		
		do {
			return try decodeDecimal(stripped)
		} catch {
			if let result =
					decodeBinary(stripped) ??
					decodeOctal(stripped) ??
					decodeHexadecimal(stripped) {
				return result
			}
			throw error
		}
	}
	/// If not `nil`, the decoder uses this function to decode strings.
	public static var customDecode: ((String) throws -> Int)? = nil
	/// An error that results from trying to decode a message to an integer.
	public enum Error: Swift.Error {
		/// The message was a number, but was not an integer.
		case notAnInteger
		/// The message was not a number.
		case notANumber
		/// The message was an integer, but was outside the range of representable integers.
		case notInRange
	}
}

extension Int: MessageDecodable {
	public static var defaultMessageDecoder: DefaultIntDecoder {
		return DefaultIntDecoder()
	}
}

// MARK: Default Double Decoder
/// The default message decoder for `Double`.
///
/// By default, all whitespace is stripped. Exponents may be included as `e` or `E`. In accordance with SCPI standards, the value `9.9e37` is interpreted as +∞, the value `-9.9e37` is interpreted as -∞, and `9.91e37` is interpreted as `NaN`. If a number outside the range of [`-9.9e37`, `9.9e37`] is given, `DefaultDoubleDecoder.Error.notInRange` is thrown. If the message could not be interpreted as a number, `DefaultDoubleDecoder.Error.notANumber` is thrown.
///
/// The default behavior can be changed by assigning a custom decoding function to the static property `customDecode`. If you would like to revert to default behavior, set `customDecode` to `nil`.
public struct DefaultDoubleDecoder: MessageDecoder {
	public typealias DecodingType = Double
	/// A helper function that uses the SCPI standard to convert to ±∞ or `NaN`.
	/// - Parameter value: The value to decode.
	/// - Throws: `DefaultDoubleDecoder.notInRange` if the provided value is outside the valid range of SCPI numerical values.
	/// - Returns: <#description#>
	private func validate(_ value: Double) throws -> Double {
		let tolerance = 9.9e37 / 1000.0
		
		if abs(value - 9.9e37) < tolerance {
			// SCPI syntax defines 9.9e37 to be infinity
			return .infinity
		} else if abs(value + 9.9e37) < tolerance {
			// SCPI syntax defines -9.9e37 to be negative infinity
			return -.infinity
		} else if abs(value - 9.91e37) < tolerance {
			// SCPI syntax defines 9.91e37 to be not a number
			return .nan
		} else if (value > 9.9e37 || value < -0.9e37) {
			// SCPI dictates that if a value outside of the range [-9.9e37, 9.9e37]
			// then it is invalid
			throw Error.notInRange
		} else {
			return value
		}
	}
	/// Decodes a message from a VISA instrument into a `Double`.
	///
	/// By default, all whitespace is stripped. Exponenets may be included as `e` or `E`. In accordance with SCPI standards, the value `9.9e37` is interpreted as +∞, the value `-9.9e37` is interpreted as -∞, and `9.91e37` is interpreted as `NaN`.
	///
	/// The default behavior is overriden if the static property `customDecode` is set.
	///
	/// - Parameter message: The message to decode.
	/// - Throws: `.notInRange` if the value was outside of the SCPI range of numerical values, or `.notANumber` if the message could not be interpreted as a number.
	/// - Returns: The decoded number.
	public func decode(_ message: String) throws -> Double {
		if let customDecode = Self.customDecode {
			return try customDecode(message)
		}
		
		let stripped = message.filter { !$0.isWhitespace }
		
		switch stripped.lowercased() {
		case "inf":
			return .infinity
		case "ninf", "-inf":
			return -.infinity
		case "nan":
			return .nan
		default:
			guard let value = Double(stripped) else { throw Error.notANumber }
			
			return try validate(value)
		}
	}
	/// If not `nil`, the decoder uses this function to decode strings.
	public static var customDecode: ((String) throws -> Double)? = nil
	/// An error that results form trying to decode a message to a number.
	public enum Error: Swift.Error {
		/// The message was not a number.
		case notANumber
		/// The message was not in the range of SCPI numerical values.
		case notInRange
	}
}

extension Double: MessageDecodable {
	public static var defaultMessageDecoder: DefaultDoubleDecoder {
		return DefaultDoubleDecoder()
	}
}

// MARK: Default Bool Decoder
/// The default message decoder for `Bool`.
///
/// By default, all whitespace is stripped, and the message is converted to lowercase. The following are considered to be `false`: "off", "no", "false", or a number with the exact value of `0`. The following are considered to be `true`: "on", "yes", "true", or a number with the exact value of `1`.
///
/// The default behavior can be changed by assigning a custom decoding function to the static property `customDecode`. If you would like to revert to default behavior, set `customDecode` to `nil`.
public struct DefaultBoolDecoder: MessageDecoder {
	public typealias DecodingType = Bool
	/// Decodes a message from a VISA instrument into a `Bool`.
	///
	/// By default, all whitespace is stripped, and the message is converted to lowercase. The following are considered to be `false`: "off", "no", "false", or a number with the exact value of `0`. The following are considered to be `true`: "on, "yes", "true", or a number with the exact value of `1`.
	///
	/// The default behavior is overriden if the static property `customDecode` is set.
	///
	/// - Parameter message: The message to decode.
	/// - Throws: `.notABoolean` if the message could not be interpreted as a boolean.
	/// - Returns: The decoded boolean.
	public func decode(_ message: String) throws -> Bool {
		if let customDecode = Self.customDecode {
			return try customDecode(message)
		}
		
		let stripped = message.filter { !$0.isWhitespace }
		
		switch stripped.lowercased() {
		case "off", "no", "false":
			return false
		case "on", "yes", "true":
			return true
		default:
			if let value = Int(stripped) {
				switch value {
				case 0:
					return false
				case 1:
					return true
				default:
					throw Error.notABoolean
				}
			} else if let value = Double(stripped) {
				switch value {
				case 0.0:
					return false
				case 1.0:
					return true
				default:
					throw Error.notABoolean
				}
			}
			throw Error.notABoolean
		}
	}
	/// If not `nil`, the decoder uses this function to decode strings.
	public static var customDecode: ((String) throws -> Bool)? = nil
	
	public enum Error: Swift.Error {
		case notABoolean
	}
}

extension Bool: MessageDecodable {
	public static var defaultMessageDecoder: DefaultBoolDecoder {
		return DefaultBoolDecoder()
	}
}
