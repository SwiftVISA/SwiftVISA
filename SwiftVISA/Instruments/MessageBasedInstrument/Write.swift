//
//  Write.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/29/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

extension MessageBasedInstrument {
	/// Writes the given message to the instrument.
	///
	/// - Parameter message: The message to write.
	/// - Throws: One of the following `VISAError` errors: `.invalidSession`, `.unsupportedOperation`, `.resourceLocked`, `.timeout`, `.rawWriteViolationProtocolViolation`, `.rawReadViolationProtocolViolation`, `.inputProtocolViolation`, `.busError`, `.invalidSetup`, `.notControllerInCharge`, `.noListeners`, `.ioError`, `.connectionLost`.
	public func write(_ message: String) throws {
		var returnCount = ViUInt32()
		let status = viWrite(session.viSession, message, ViUInt32(message.count), &returnCount)
		
		if status < VI_SUCCESS {
			throw VISAError(status)
		}
	}
}
