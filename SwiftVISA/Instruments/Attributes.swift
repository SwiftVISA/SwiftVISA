//
//  Attributes.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 6/3/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

extension Instrument {
	/// sets the given NI-VISA attribute on the instrument
	///
	/// - Throws: ???
	func setAttibute(_ attributeId: ViAttr, value: String) throws {
		#warning("Unimlemented")
		// TODO make sure that attribute responses are never greater than 2048 bytes
		let buffer = ViPBuf.allocate(capacity: 2048)
		
		// let status = viSetAttribute(session.viSession, attributeId, value)
		// guard status >= VI_SUCCESS else { throw VISAError(status)}
	}
	
	/// Gets the given NI-VISA attribute on the instrument
	///
	/// - Throws: ???
	func getAttribute(_ attributeId: ViAttr) throws -> String {
		#warning("Not tested")
		let buffer = ViPBuf.allocate(capacity: 2048)
		let status = viGetAttribute(session.viSession, attributeId, buffer)
		
		guard status >= VI_SUCCESS else { throw VISAError(status) }
		// convert the data to a readable string format
		let pointer = UnsafeRawPointer(buffer)
		let bytes = MemoryLayout<UInt8>.stride * 2048
		let data = Data(bytes: pointer, count: bytes)
		guard let string = String(data: data, encoding: .ascii) else {
			throw VISAError.couldNotDecode
		}
		let startIndex = string.startIndex
		guard let endIndex = string.firstIndex(of: "\0") else {
			// TODO remove this print when "rigorous" testing done
			print("Buffer size bad (null byte not found) D:")
			throw VISAError.couldNotDecode
		}
		return String(string[startIndex..<endIndex])
	}
}
