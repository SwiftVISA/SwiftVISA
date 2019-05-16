//
//  Voltage.swift
//  SwiftVISATests
//
//  Created by Avinash on 5/15/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

public func setVoltage(to instrument: Instrument, voltage: Double) throws {
	try visaWrite(to: instrument, "SOURCE1:FUNCTION SQU:VOLTAGE \(voltage)")
}

public func readVoltage(from instrument: Instrument) throws -> Double {
	try visaWrite(to: instrument, "MEASURE:VOLTAGE:DC?")
	let voltageString = try visaRead(from: instrument, bufferSize: 200)
	guard let voltage = Double(voltageString) else { throw ReadError.wrongType }
	return voltage
}
