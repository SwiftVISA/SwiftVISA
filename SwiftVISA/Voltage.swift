//
//  Voltage.swift
//  SwiftVISATests
//
//  Created by Avinash on 5/15/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

/// A function for an AC current.
///
/// - sine: A sine wave.
/// - square: A square wave.
public enum VoltageFunction {
	case sine
	case square
}

extension VoltageFunction {
	/// The VISA string that devfines the function
	var descriptor: String {
		switch self {
		case .sine:
			return "SIN"
		case .square:
			return "SQU"
		}
	}
}

/// Turns the output on for a waveform generator.
///
/// - Parameter instrument: The instrument to turn output on for.
/// - Throws: If the output could not be turned on.
public func turnOutputOn(for instrument: Instrument) throws {
	try visaWrite(to: instrument, "OUTPUT1 ON")
}
	
/// Sets the waveform generator to a DC current with the given offset voltage.
///
/// - Parameters:
///   - instrument: The waveform generator to set the voltage for.
///   - voltage: The voltage to set to in volts.
/// - Throws: If the voltage could not be set.
public func setVoltage(to instrument: Instrument, offsetVoltage voltage: Double) throws {
	try visaWrite(to: instrument, "SOURCE1:FUNCTION DC")
	try visaWrite(to: instrument, "SOURCE1:VOLTAGE:OFFSET \(voltage)")
}

/// Sets the waveform generator to an AC current with the given peak voltage and function.
///
/// - Parameters:
///   - instrument: The waveform generator to set the voltage for.
///   - voltage: The peak voltage to set to in volts.
///   - function: The AC function to set to.
/// - Throws: If the voltage could not be set.
public func setVoltage(to instrument: Instrument,
											 peakVoltage voltage: Double,
											 acFunction function: VoltageFunction) throws {
	try visaWrite(to: instrument, "SOURCE1:FUNCTION \(function.descriptor)")
	try visaWrite(to: instrument, "SOURCE1:VOLTAGE \(voltage)")
}

/// Reads the voltage from a multimeter.
///
/// - Parameter instrument: The multimeter to read from.
/// - Returns: The voltage in volts.
/// - Throws: If the voltage could not be read.
public func readDCVoltage(from instrument: Instrument) throws -> Double {
	try visaWrite(to: instrument, "MEASURE:VOLTAGE:DC?")
	var voltageString = try visaRead(from: instrument, bufferSize: 200)
	// The returned voltage ends with a new line character -- remove this character
	voltageString.removeLast()
	guard let voltage = Double(voltageString) else { throw ReadError.wrongType }
	return voltage
}

public func setImpedance(for instrument: Instrument, impedance: Double) throws {
	let adjustedImpedance: Double = {
		if impedance == .nan {
			return 0.0
		}
		if impedance < 0 {
			return 0.0
		}
		return impedance
	}()
	
	
	try visaWrite(to: instrument, "OUTPUT:LOAD ")
}
