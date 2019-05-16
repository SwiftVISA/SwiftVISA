//
//  Write.swift
//  SwiftVISA
//
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

/// Writes the given string to the instrument.
///
/// - Parameters:
///   - instrument: The instrument to write to.
///   - string: The string to write.
/// - Throws: If the data could not be properly written.
func visaWrite(to instrument: Instrument, _ string: String) throws {
	var returnCount = ViUInt32()
	let status = viWrite(instrument.session, string, ViUInt32(string.count), &returnCount)
	
	if status < VI_SUCCESS {
		throw WriteError(status) ?? UnknownError()
	}
}
