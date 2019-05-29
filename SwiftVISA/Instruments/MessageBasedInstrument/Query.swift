//
//  Query.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/29/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import Foundation

extension MessageBasedInstrument {
	/// Writes the given message to the instrument and then reads data from the given instrument and decodes it to the given type using the given decoder.
	///
	/// - Parameters:
	///   - message: The message to write to the instrument.
	///   - type: The type to return.
	///   - decoder: The decoder to use to decode the data.
	/// - Returns: The decoded value.
	/// - Throws: One of the following `VISAError` errors: `.invalidSession`, `.unsupportedOperations`, `.resourceLocked`, `.timeout`, `.rawWriteProtocolViolation`, `.rawReadProtocolViolation`, `inputProtocolViolation`, `.outputProtocolViolation`, `.busError`, `.invalidSetup`, `.notControllerInCharge`, `.noListeners`, `.parityError`, `.framingError`, `.overrunError`, `.ioError`, `.connectionLost`, `.couldNotDecode`.
	public func query<T, D: VISADecoder>(_ message: String, as type: T.Type, decoder: D) throws -> T where D.DecodingType == T {
		try write(message)
		return try read(as: T.self, decoder: decoder)
	}
	
	/// Writes the given message to the instrument and then reads data from the given instrument and decodes it to the given type using the default decoder.
	///
	/// - Parameters:
	///   - message: The message to write to the instrument.
	///   - type: The type to return.
	/// - Returns: The decoded value.
	/// - Throws: One of the following `VISAError` errors: `.invalidSession`, `.unsupportedOperations`, `.resourceLocked`, `.timeout`, `.rawWriteProtocolViolation`, `.rawReadProtocolViolation`, `inputProtocolViolation`, `.outputProtocolViolation`, `.busError`, `.invalidSetup`, `.notControllerInCharge`, `.noListeners`, `.parityError`, `.framingError`, `.overrunError`, `.ioError`, `.connectionLost`, `.couldNotDecode`.
	public func query<T: VISADecodable>(_ message: String, as type: T.Type) throws -> T {
		try write(message)
		return try read(as: T.self)
	}
}
