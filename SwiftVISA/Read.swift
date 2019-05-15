//
//  Read.swift
//  SwiftVISA
//
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

enum ReadResult {
	case success (String)
	case error (ViStatus)
}

func visaRead(to session: ViSession, bufferSize: Int) -> ReadResult {
	let buffer = ViPBuf.allocate(capacity: bufferSize)
	var returnCount = ViUInt32()
	let status = viRead(session, buffer, ViUInt32(bufferSize), &returnCount)
	
	guard status >= VI_SUCCESS else {
		return .error(status)
	}
	
	let pointer = UnsafeRawPointer(buffer)
	let bytes = MemoryLayout<UInt8>.stride * bufferSize
	let data = Data(bytes: pointer, count: bytes)
	guard let string = String(data: data, encoding: .ascii) else {
		// FIXME: Fix this
		return .error(0)
	}
	guard returnCount <= bufferSize && returnCount >= 0 else {
		// FIXME: Fix this
		return .error(0)
	}
	let startIndex = string.startIndex
	let endIndex = string.index(startIndex, offsetBy: String.IndexDistance(returnCount))
	return .success(String(string[startIndex..<endIndex]))
}
