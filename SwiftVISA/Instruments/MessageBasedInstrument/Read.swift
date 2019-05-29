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
	/// - Throws: One of the following `VISAError` errors: `.invalidSession`, `.unsupportedOperations`, `.resourceLocked`, `.timeout`, `.rawWriteProtocolViolation`, `.rawReadProtocolViolation`, `.outputProtocolViolation`, `.busError`, `.invalidSetup`, `.notControllerInCharge`, `.noListeners`, `.parityError`, `.framingError`, `.overrunError`, `.ioError`, `.connectionLost`.
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
	/// - Throws: One of the following `VISAError` errors: `.invalidSession`, `.unsupportedOperations`, `.resourceLocked`, `.timeout`, `.rawWriteProtocolViolation`, `.rawReadProtocolViolation`, `.outputProtocolViolation`, `.busError`, `.invalidSetup`, `.notControllerInCharge`, `.noListeners`, `.parityError`, `.framingError`, `.overrunError`, `.ioError`, `.connectionLost`, `.couldNotDecode`.
	public func read<T, D: VISADecoder>(as type: T.Type, decoder: D) throws -> T where D.DecodingType == T {
		let visaString = try read()
		return try decoder.decode(visaString)
	}
	
	/// Reads data from the instrument and decodes it into the given type using the default decoder.
	///
	/// - Parameter type: The type to return.
	/// - Returns: The decoded value.
	/// - Throws: One of the following `VISAError` errors: `.invalidSession`, `.unsupportedOperations`, `.resourceLocked`, `.timeout`, `.rawWriteProtocolViolation`, `.rawReadProtocolViolation`, `.outputProtocolViolation`, `.busError`, `.invalidSetup`, `.notControllerInCharge`, `.noListeners`, `.parityError`, `.framingError`, `.overrunError`, `.ioError`, `.connectionLost`, `.couldNotDecode`.
	public func read<T: VISADecodable>(as type: T.Type) throws -> T {
		let visaString = try read()
		return try T(visaString: visaString)
	}
}
