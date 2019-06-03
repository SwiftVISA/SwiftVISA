//
//  Query.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/29/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//
import Foundation
extension MessageBasedInstrument {
	/// Private function to convert a TimeInterval to a UInt32 for use in usleep
	///
	/// - Parameters:
	///		- interval: The TimeInterval to be converted
	private func toUInt32(_ interval: TimeInterval) -> UInt32 {
		// TODO: usleep() appears to have a maximum delay of 1 second.
		return UInt32(floor(interval * 1e3)) // Multiply by 1000 to get microseconds, then convert to UInt32
	}

	/// Writes the given message to the instrument and then reads data from the given instrument and decodes it to the given type using the given decoder.
	///
	/// - Parameters:
	///   - message: The message to write to the instrument.
	///   - type: The type to return.
	///   - decoder: The decoder to use to decode the data.
	/// - Returns: The decoded value.
	/// - Throws: One of the following `VISAError` errors:
	///   - `.invalidSession`
	///   - `.unsupportedOperations`
	///   - `.resourceLocked`
	///   - `.timeout`
	///   - `.rawWriteProtocolViolation`
	///   - `.rawReadProtocolViolation`
	///   - `inputProtocolViolation`
	///   - `.outputProtocolViolation`
	///   - `.busError`
	///   - `.invalidSetup`
	///   - `.notControllerInCharge`
	///   - `.noListeners`
	///   - `.parityError`
	///   - `.framingError`
	///   - `.overrunError`
	///   - `.ioError`
	///   - `.connectionLost`
	///   - `.couldNotDecode`
	public func query<T, D: VISADecoder>(_ message: String, as type: T.Type, decoder: D, readDelay: TimeInterval = 0.0) throws -> T where D.DecodingType == T {
		try write(message)
		usleep(toUInt32(readDelay))
		return try read(as: T.self, decoder: decoder)
	}
	
	/// Writes the given message to the instrument and then reads data from the given instrument and decodes it to the given type using the default decoder.
	///
	/// - Parameters:
	///   - message: The message to write to the instrument.
	///   - type: The type to return.
	/// - Returns: The decoded value.
	/// - Throws: One of the following `VISAError` errors:
	///   - `.invalidSession`
	///   - `.unsupportedOperations`
	///   - `.resourceLocked`
	///   - `.timeout`
	///   - `.rawWriteProtocolViolation`
	///   - `.rawReadProtocolViolation`
	///   - `inputProtocolViolation`
	///   - `.outputProtocolViolation`
	///   - `.busError`
	///   - `.invalidSetup`
	///   - `.notControllerInCharge`
	///   - `.noListeners`
	///   - `.parityError`
	///   - `.framingError`
	///   - `.overrunError`
	///   - `.ioError`
	///   - `.connectionLost`
	///   - `.couldNotDecode`
	public func query<T: VISADecodable>(_ message: String, as type: T.Type, readDelay: TimeInterval = 0.0) throws -> T {
		try write(message)
		usleep(toUInt32(readDelay))
		return try read(as: T.self)
	}

	/// Writes the given message to the instrument and then reads multiple data points from the given instrument and decodes it to the given type using the default decoder.
	///
	/// - Parameters:
	///   - message: The message to write to the instrument.
	///   - type: The type to return.
	/// - Returns: The decoded value.
	/// - Throws: One of the following `VISAError` errors:
	///   - `.invalidSession`
	///   - `.unsupportedOperations`
	///   - `.resourceLocked`
	///   - `.timeout`
	///   - `.rawWriteProtocolViolation`
	///   - `.rawReadProtocolViolation`
	///   - `inputProtocolViolation`
	///   - `.outputProtocolViolation`
	///   - `.busError`
	///   - `.invalidSetup`
	///   - `.notControllerInCharge`
	///   - `.noListeners`
	///   - `.parityError`
	///   - `.framingError`
	///   - `.overrunError`
	///   - `.ioError`
	///   - `.connectionLost`
	///   - `.couldNotDecode`
	public func query<T: VISADecodable>(_ message: String, as type: T.Type, numberOfReads: Int, timeBetweenReads: TimeInterval = 0.5, readDelay: TimeInterval = 0.0) throws -> [T?] {
		var readList: [T?] = []

		for var i in 1...numberOfReads {
			let startTime = Date()
			let nextRead = try self.query(message, as: type, readDelay: readDelay)

			let endTime = Date()
			let timeElapsed = endTime.timeIntervalSince(startTime)

			// Calculation of the time delay before we call read again
			let currentTimeDelay = timeBetweenReads - timeElapsed

			if (currentTimeDelay > 0) {
				readList.append(nextRead)
				usleep(toUInt32(currentTimeDelay))
			} else {
				// If the read took longer than the time elapsed, than skip the next one and insert nil
				readList.append(nil)
				i += 1
			}
		}

		return readList
	}

	/// Writes the given message to the instrument and then reads data from the given instrument and decodes it to the given type using the given decoder.
	///
	/// - Parameters:
	///   - message: The message to write to the instrument.
	///   - type: The type to return.
	///   - decoder: The decoder to use to decode the data.
	/// - Returns: The decoded value.
	/// - Throws: One of the following `VISAError` errors:
	///   - `.invalidSession`
	///   - `.unsupportedOperations`
	///   - `.resourceLocked`
	///   - `.timeout`
	///   - `.rawWriteProtocolViolation`
	///   - `.rawReadProtocolViolation`
	///   - `inputProtocolViolation`
	///   - `.outputProtocolViolation`
	///   - `.busError`
	///   - `.invalidSetup`
	///   - `.notControllerInCharge`
	///   - `.noListeners`
	///   - `.parityError`
	///   - `.framingError`
	///   - `.overrunError`
	///   - `.ioError`
	///   - `.connectionLost`
	///   - `.couldNotDecode`
	public func query<T, D: VISADecoder>(_ message: String, as type: T.Type, decoder: D, numberOfReads: Int, timeBetweenReads: TimeInterval = 0.5, readDelay: TimeInterval = 0.0) throws -> [T?] where D.DecodingType == T {
		#warning("Not tested")
		var readList: [T?] = []

		for var i in 1...numberOfReads {
			let startTime = Date()
			let nextRead = try query(message, as: type, decoder: decoder, readDelay: readDelay)

			let endTime = Date()
			let timeElapsed = endTime.timeIntervalSince(startTime)

			// Calculation of the time delay before we call read again
			let currentTimeDelay = timeBetweenReads - timeElapsed

			if (currentTimeDelay > 0) {
				readList.append(nextRead)
				usleep(toUInt32(currentTimeDelay))
			} else {
				// If the read took longer than the time elapsed, than skip the next one and insert nill
				readList.append(nil)
				i += 1
			}
		}

		return readList
	}
}
