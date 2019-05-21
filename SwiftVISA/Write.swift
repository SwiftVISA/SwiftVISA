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
public func visaWrite<T, E: VISAEncoder>(to instrument: Instrument, _ value: T, encoder: E) throws where E.EncodingType == T {
	let string = try encoder.encode(value)
	var returnCount = ViUInt32()
	let status = viWrite(instrument.session, string, ViUInt32(string.count), &returnCount)
	
	if status < VI_SUCCESS {
		throw WriteError(status) ?? UnknownError()
	}
}

public func visaWrite<T: VISAEncodable>(to instrument: Instrument, _ value: T) throws {
	let encoder = T.DefaultVISAEncoder()
	try visaWrite(to: instrument, value, encoder: encoder)
}
