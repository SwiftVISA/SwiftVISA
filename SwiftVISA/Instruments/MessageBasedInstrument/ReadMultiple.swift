//
// Created by Avinash on 2019-05-29.
// Copyright (c) 2019 SwiftVISA. All rights reserved.
//

import Foundation

extension MessageBasedInstrument {
	// TODO: Why is the default time delay 25 ms? Should there be any default? There probably shouldn't be a default value unless the value has significant meaning and/or will be used in a large percentage of calls.
	// TODO: Should the function allow a value of 0 for timeDelay that indicates that the reads should be performed immediately after one another? This would result in an array with readings from unknown time intervals, but may be useful for reading data as fast as possible. If this was allowed, maybe 0 should be the default value?
	// TODO: Should this method signiture be changed? The function name is not very "swifty". The first argument label does not read as English, and the timeDelay argument label is confusing: is this a delay before reading, after, during, etc.? Perhaps a better signiture would be "read(as:numberOfTimes:timeInterval)" here however, the timeInterval argument label may be similarly vague. The name "read(as:numberOfTimes:timeStep)" or "read(as:numberOfTimes:timeBetweenReads)" could also work, however the first reads oddly to me, and the second is fairly long. Another benefit to any three of these names is that the signature would match the read(as:) method but with additional parameters. This would help aid homogeneity in the code.
	// TODO: Should this function throw? If any of the values has an error this function will throw. It may be more useful to return nil for calls that throw instead. Perhaps there should be a varient of the function that does not throw, while keeping this varient? Perhaps and array of the Result type could be used (an instance of Result<T, E> is either an instance of type T (indicating success) or of type E (where E conforms to Error, and indicates an error)).
	/// Repeatedly reads values from an instrument with the specified amount of time between each read and returns an array of these values.
	///
	/// This function performs `numberOfReads` number of reads sequentially and returns the results from the read as an array. Each reading is taken with `timeDelay` number of seconds between them. Each non-nil sequential value in the array is guarenteed to have occurred with `timeDelay` number of seconds between them. If the instrument's read could not be completed in `timeDelay` number of seconds, then the next value(s) in the array are `nil`, indicating that this time index was skipped. Further, the resuling array will always have `numberOfReads` elements.
	///
	/// **Example:**
	///
	/// The following call is made:
	///
	///     readMultiple(numberOfReads: 5, as: Int.self, timeDelay: 0.5)
	///
	/// The first read takes 0.4 seconds, and returns a `3`. The computer waits 0.1 seconds before making the next read. The next read takes 0.3 seconds, and returns a `5`. The computer waits 0.2 seconds before making the next read. The next read takes 0.6 seconds, and returns a `6`. Because the next read was scheduled to happen 0.1 seconds ago, the read is skipped, and `nil` is used for this time index. The last read is made and takes 0.8 seconds and returns `5`. Although the read operation took longer than the time delay, there are no further scheduled read operations, so an additional `nil` is not used.
	///
	/// The resulting array is returned:
	///
	///     [3, 5, 6, nil, 5]
	///
	/// - Parameters:
	///   - numberOfReads: The number of reads to perform.
	///   - type: The type to be returned from each read.
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
	public func readMultiple<T: VISADecodable>(numberOfReads: Int, as type: T, timeDelay: TimeInterval = 0.025) throws -> [T?] {
		#warning("Not tested")
		var readList: [T?] = []
		
		for _ in 1...numberOfReads {
			let startTime = Date()
			readList.append(try? self.read(as: T.self))
			let endTime = Date()
			
			let timeElapsed = endTime.timeIntervalSince(startTime)
			
			// Calculation of the time delay before we call read again
			let currentTimeDelay = timeDelay - timeElapsed
			
			if (currentTimeDelay < 0) {
				usleep(UInt32(currentTimeDelay * 1000000.0))
			}
		}
		
		return readList
	}
	
	// TODO: Why is the default time delay 25 ms? Should there be any default? There probably shouldn't be a default value unless the value has significant meaning and/or will be used in a large percentage of calls.
	// TODO: Should the function allow a value of 0 for timeDelay that indicates that the reads should be performed immediately after one another? This would result in an array with readings from unknown time intervals, but may be useful for reading data as fast as possible. If this was allowed, maybe 0 should be the default value?
	// TODO: Should this method signiture be changed? The function name is not very "swifty". The first argument label does not read as English, and the timeDelay argument label is confusing: is this a delay before reading, after, during, etc.? Perhaps a better signiture would be "read(as:numberOfTimes:timeInterval)" here however, the timeInterval argument label may be similarly vague. The name "read(as:numberOfTimes:timeStep)" or "read(as:numberOfTimes:timeBetweenReads)" could also work, however the first reads oddly to me, and the second is fairly long. Another benefit to any three of these names is that the signature would match the read(as:) method but with additional parameters. This would help aid homogeneity in the code.
	// TODO: Should this function throw? If any of the values has an error this function will throw. It may be more useful to return nil for calls that throw instead. Perhaps there should be a varient of the function that does not throw, while keeping this varient? Perhaps and array of the Result type could be used (an instance of Result<T, E> is either an instance of type T (indicating success) or of type E (where E conforms to Error, and indicates an error)).
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
	public func readMultiple<T, D: VISADecoder>(numberOfReads: Int, as type: T, decoder: D, timeDelay: TimeInterval = 0.025) throws -> T where D.DecodingType == T {
		#warning("Not implemented")
		return try(read(as: T.self, decoder: decoder))
	}
}
