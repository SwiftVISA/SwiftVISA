//
//  Read.swift
//  SwiftVISA
//
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

// TODO: Remove this function.
#warning("The following function should be removed.")
/// Reads data from the given instrument. The string returned may not exceed the buffer size.
///
/// - Parameters:
///   - instrument: The instrument to read from.
///   - bufferSize: The maximum number of characters to read.
/// - Returns: The data read from the instrument.
/// - Throws: If the data could not be properly read.
public func visaRead(from instrument: Instrument, bufferSize: Int) throws -> String {
	let buffer = ViPBuf.allocate(capacity: bufferSize)
	var returnCount = ViUInt32()
	let status = viRead(instrument.session.viSession, buffer, ViUInt32(bufferSize), &returnCount)

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

// TODO: Remove this function.
#warning("The following function should be removed.")
public func visaRead<T, D: VISADecoder>(from instrument: Instrument, as type: T, bufferSize: Int, decoder: D) throws -> T where D.DecodingType == T {
	let string = try visaRead(from: instrument, bufferSize: bufferSize)
	return try decoder.decode(string)
}

// TODO: Remove this function.
#warning("The following function should be removed.")
public func visaRead<T: VISADecodable>(from instrument: Instrument, as type: T, bufferSize: Int) throws -> T {
	let string = try visaRead(from: instrument, bufferSize: bufferSize)
	return try T(visaString: string)
}