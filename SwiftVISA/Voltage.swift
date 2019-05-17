//
//  Voltage.swift
//  SwiftVISATests
//
//  Created by Avinash on 5/15/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

public enum VoltageFunction {
	case sine
	case square
}

extension VoltageFunction {
	var descriptor: String {
		switch self {
		case .sine:
			return "SIN"
		case .square:
			return "SQU"
		}
	}
}

public func turnOutputOn(for instrument: Instrument) throws {
	try visaWrite(to: instrument, "OUTPUT1 ON")
}
	
public func setVoltage(to instrument: Instrument, offsetVoltage voltage: Double) throws {
	try visaWrite(to: instrument, "SOURCE1:FUNCTION DC")
	try visaWrite(to: instrument, "SOURCE1:VOLTAGE:OFFSET \(voltage)")
}

public func setVoltage(to instrument: Instrument,
											 peakVoltage voltage: Double,
											 acFunction function: VoltageFunction) throws {
	try visaWrite(to: instrument, "SOURCE1:FUNCTION \(function.descriptor)")
	try visaWrite(to: instrument, "SOURCE1:VOLTAGE \(voltage)")
}

public func readDCVoltage(from instrument: Instrument) throws -> Double {
	try visaWrite(to: instrument, "MEASURE:VOLTAGE:DC?")
	var voltageString = try visaRead(from: instrument, bufferSize: 200)
	// The returned voltage ends with a new line character -- remove this character
	voltageString.removeLast()
	guard let voltage = Double(voltageString) else { throw ReadError.wrongType }
	return voltage
}
