//
//  Query.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/29/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

extension MessageBasedInstrument {
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
	public func query<T: VISADecodable>(_ message: String, as type: T.Type) throws -> T {
		try write(message)
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
	public func query<T: VISADecodable>(_ message: String, as type: T.Type, numberOfReads: Int, timeBetweenReads: TimeInterval = 0.5) throws -> [T?] {
		var readList: [T?] = []

		for var i in 1...numberOfReads {
			let startTime = Date()
			let nextRead = try self.query(message, as: type)

			let endTime = Date()
			let timeElapsed = endTime.timeIntervalSince(startTime)

			// Calculation of the time delay before we call read again
			let currentTimeDelay = timeBetweenReads - timeElapsed

			if (currentTimeDelay > 0) {
				readList.append(nextRead)
				let timeDelay = UInt32(floor(currentTimeDelay * 1e3))
				usleep(timeDelay)
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
	public func query<T, D: VISADecoder>(_ message: String, as type: T.Type, decoder: D, numberOfReads: Int, timeBetweenReads: TimeInterval = 0.5) throws -> [T?] where D.DecodingType == T {
		#warning("Not tested")
		var readList: [T?] = []

		for var i in 1...numberOfReads {
			let startTime = Date()
			let nextRead = try query(message, as: type, decoder: decoder)

			let endTime = Date()
			let timeElapsed = endTime.timeIntervalSince(startTime)

			// Calculation of the time delay before we call read again
			let currentTimeDelay = timeBetweenReads - timeElapsed

			if (currentTimeDelay > 0) {
				readList.append(nextRead)
				let timeDelay = UInt32(floor(currentTimeDelay * 1e3))
				usleep(timeDelay)
			} else {
				// If the read took longer than the time elapsed, than skip the next one and insert nill
				readList.append(nil)
				i += 1
			}
		}

		return readList
	}
}
