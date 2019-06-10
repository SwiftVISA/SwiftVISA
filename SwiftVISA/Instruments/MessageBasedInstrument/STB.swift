//
// Created by Avinash on 2019-06-09.
// Copyright (c) 2019 SwiftVISA. All rights reserved.
//

import CVISA

extension MessageBasedInstrument {
	/// Reads the service request status byte.
	///
	/// - Returns: The service request byte.
	/// - Throws: TODO: Add errors.
	public func readStatusByte() throws -> Data {
		var result = UInt16() // AKA: UnsafeMutablePointer<UInt16>
		let status = viReadSTB(session.viSession, &result)
		
		guard status >= VI_SUCCESS else {
			throw VISAError(status)
		}
		
		let pointer = UnsafeRawPointer(&result)
		let bytes = MemoryLayout<UInt16>.stride
		return Data(bytes: pointer, count: bytes)
	}
}
