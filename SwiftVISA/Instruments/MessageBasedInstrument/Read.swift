//
//  Read.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/29/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

extension MessageBasedInstrument {
	/// Reads data from the instrument.
	///
	/// - Returns: The data read from the instrument.
	/// - Throws: One of the following `VISAError` errors:
	///   - `.invalidSession`
	///   - `.unsupportedOperations`
	///   - `.resourceLocked`
	///   - `.timeout`
	///   - `.rawWriteProtocolViolation`
	///   - `.rawReadProtocolViolation`
	///   - `.outputProtocolViolation`
	///   - `.busError`
	///   - `.invalidSetup`
	///   - `.notControllerInCharge`
	///   - `.noListeners`
	///   - `.parityError`
	///   - `.framingError`, `.overrunError`, `.ioError`, `.connectionLost`.
	private func read() throws -> String {
		let buffer = ViPBuf.allocate(capacity: bufferSize)
		var returnCount = ViUInt32()
		let status = viRead(session.viSession, buffer, ViUInt32(bufferSize), &returnCount)
		
		guard status >= VI_SUCCESS else {
			throw VISAError(status)
		}
	
		let pointer = UnsafeRawPointer(buffer)
		let bytes = MemoryLayout<UInt8>.stride * bufferSize
		let data = Data(bytes: pointer, count: bytes)
		guard let string = String(data: data, encoding: .ascii) else {
			throw VISAError.couldNotDecode
		}
		// TODO: Determine if this condition is needed
		//	guard returnCount <= bufferSize && returnCount >= 0 else {
		//		throw ReadError.returnCountExceededBufferLength
		//	}
		let startIndex = string.startIndex
		let endIndex = string.index(startIndex, offsetBy: String.IndexDistance(returnCount))
		return String(string[startIndex..<endIndex])
	}
	
	/// Reads data from the instrument and decodes it into the given type using the given decoder.
	///
	/// - Parameters:
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
	public func read<T, D: VISADecoder>(as type: T.Type, decoder: D) throws -> T where D.DecodingType == T {
		let visaString = try read()
		return try decoder.decode(visaString)
	}
	
	/// Reads data from the instrument and decodes it into the given type using the default decoder.
	///
	/// - Parameter type: The type to return.
	/// - Returns: The decoded value.
	/// - Throws: One of the following `VISAError` errors:
	///   - `.invalidSession`
	///   - `.unsupportedOperations`
	///   - `.resourceLocked`
	///   - `.timeout`
	///   - `.rawWriteProtocolViolation`
	///   - `.rawReadProtocolViolation`
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
	public func read<T: VISADecodable>(as type: T.Type) throws -> T {
		let visaString = try read()
		return try T(visaString: visaString)
	}

	// TODO: Why is the default time delay 25 ms? Should there be any default? There probably shouldn't be a default value unless the value has significant meaning and/or will be used in a large percentage of calls.
	// TODO: Should the function allow a value of 0 for timeDelay that indicates that the reads should be performed immediately after one another? This would result in an array with readings from unknown time intervals, but may be useful for reading data as fast as possible. If this was allowed, maybe 0 should be the default value?
	// TODO: Should this method signiture be changed? The function name is not very "swifty". The first argument label does not read as English, and the timeDelay argument label is confusing: is this a delay before reading, after, during, etc.? Perhaps a better signiture would be "read(as:numberOfTimes:timeInterval)" here however, the timeInterval argument label may be similarly vague. The name "read(as:numberOfTimes:timeStep)" or "read(as:numberOfTimes:timeBetweenReads)" could also work, however the first reads oddly to me, and the second is fairly long. Another benefit to any three of these names is that the signature would match the read(as:) method but with additional parameters. This would help aid homogeneity in the code.
	/// Repeatedly reads values from an instrument with the specified amount of time between each read and returns an array of these values.
	///
	/// This function performs `numberOfReads` number of reads sequentially and returns the results from the read as an array. Each reading is taken with `timeDelay` number of seconds between them. Each non-nil sequential value in the array is guarenteed to have occurred with `timeDelay` number of seconds between them. If the instrument's read could not be completed in `timeDelay` number of seconds, then the next value(s) in the array are `nil`, indicating that this time index was skipped. Further, the resuling array will always have `numberOfReads` elements.
	///
	/// The resulting array is returned:
	///
	///     [3, 5, 6, nil, 5]
	///
	/// - Parameters:
	///   - numberOfReads: The number of reads to perform.
	///   - type: The type to be returned from each read.
	///   - decoder: The decoder to use to decode the data.
	///   - timeDelay: The amount of time between each successive read operation, defaults to 25 ms.
	/// - Returns: An array of the results of the successive read operations.
	/// - Throws: One of the following `VISAError` errors:
	///   - `.invalidSession`
	///   - `.unsupportedOperations`
	///   - `.resourceLocked`
	///   - `.timeout`
	///   - `.rawWriteProtocolViolation`
	///   - `.rawReadProtocolViolation`
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
	public func read<T, D: VISADecoder>(as type: T.Type, decoder: D, numberOfReads: Int, timeBetweenReads: TimeInterval = 0.025) throws -> [T?] where D.DecodingType == T {
		#warning("Not unit tested")
		var readList: [T?] = []

		for var i in 1...numberOfReads {
			let startTime = Date()
			do {
				readList.append(try self.read(as: T.self, decoder: decoder))
			} catch {
				// TODO: If the read throws an error, I believe a nil will be appended into the readList
				// If not, simply append it here?
			}

			let endTime = Date()

			let timeElapsed = endTime.timeIntervalSince(startTime)

			// Calculation of the time delay before we call read again
			let currentTimeDelay = timeBetweenReads - timeElapsed

			if (currentTimeDelay < 0) {
				usleep(UInt32(currentTimeDelay * 1000000.0))
			} else {
				// If the read took longer than the time elapsed, than skip the next one and insert nill
				readList.append(nil)
				i += 1
			}
		}

		return readList
	}
}
