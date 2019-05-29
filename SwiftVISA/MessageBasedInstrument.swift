//
// Created by Avinash on 2019-05-28.
// Copyright (c) 2019 SwiftVISA. All rights reserved.
//

import CVISA

public protocol MessageBasedInstrument : Instrument {
	var bufferSize: Int { get set }
	var buffer: UnsafeMutableRawBufferPointer { get }
}

/// MARK: Read
extension MessageBasedInstrument {
	// Read from the instrument
	//  This is the general method that simply returns a string
	public func read() throws -> String {
		// Setup the buffer
		let buffer = ViPBuf.allocate(capacity: bufferSize)
		var returnCount = ViUInt32()
		
		// Call the read
		let status = viRead(session.viSession, buffer, ViUInt32(bufferSize), &returnCount)
		
		// Guard against an error
		guard status >= VI_SUCCESS else { throw VISAError(status) }
		
		// Handle the conversion from pointer stuff to string
		let pointer = UnsafeRawPointer(buffer)
		let numberOfBytes = MemoryLayout<UInt8>.stride * bufferSize
		let data = Data(bytes: pointer, count: numberOfBytes)
		
		guard let string = String(data: data, encoding: .ascii) else {
			throw VISAError.couldNotDecode
		}
		
		// TODO: Determine if this assertion is needed
		// If this assertion is needed, make an associated error for it, otherwise, remove the commented code below
//		guard returnCount <= bufferSize && returnCount >= 0 else {
//			throw VISAError.someError
//		}
		
		let startIndex = string.startIndex
		let endIndex = string.index(startIndex, offsetBy: String.IndexDistance(returnCount))
		
		return String(string[startIndex ..< endIndex])
	}
	
	public func read<T: VISADecodable>(return_type: T) throws -> T {
		return try T(visaString: read())
	}
	
	// This overload allows a decoder to be specified
	public func read<T, D: VISADecoder>(return_type: T, decoder: D) throws -> T where D.DecodingType == T {
		return try decoder.decode(read())
	}
}

/// MARK: Write
extension MessageBasedInstrument {
	// Writes the specified string to the instrument
	public func write(command: String) throws {
		var returnCount = ViUInt32()
		let status = viWrite(session.viSession, command, ViUInt32(command.count), &returnCount)
		
		guard status >= VI_SUCCESS else {
			throw VISAError(status)
		}
	}
}

/// MARK: Query
extension MessageBasedInstrument {
	// Query: a write, then a read.
	public func query(command: String) throws -> String {
		try write(command: command)
		return try read()
	}
	
	public func query<T: VISADecodable>(command: String, return_type: T) throws -> T {
		return try T(visaString: query(command: command))
	}
	
	public func query<T, D: VISADecoder>(command:String, return_type: T, decoder: D) throws -> T where D.DecodingType == T {
		return try decoder.decode(query(command: command))
	}
}
