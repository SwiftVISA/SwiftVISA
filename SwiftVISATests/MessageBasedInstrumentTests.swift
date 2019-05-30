//
// Created by Avinash on 2019-05-28.
// Copyright (c) 2019 SwiftVISA. All rights reserved.
//

import XCTest
@testable import SwiftVISA

/// This class tests MessageBasedInstrument by running tests against and agilent
class MessageBasedInstrumentTests : XCTestCase {
	var multimeterInstrument: MessageBasedInstrument?
	var waveformGeneratorInstrument: MessageBasedInstrument?
	var multimeterUII: String = "USB0::0x0957::0x1A07::MY53205040::0::INSTR"
	var waveformGeneratorUUI: String = "USB0::0x0957::0x2607::MY52200879::INSTR";
	
	// Start the session to all the instruments
	override func setUp() {
		let im = InstrumentManager.default
		//        multimeterInstrument = rm.makeInstrument(named: multimeterUII) as? MessageBasedInstrument
		
	}
	
	// Remove all the sessions
	override func tearDown() {
		
	}
	
	// Test the write command by setting the waveform characteristics
	func testSetWaveformCharacteristics() {
		// First, ensure we have an instrument
		XCTAssertNotNil(waveformGeneratorInstrument)
		
		do {
			// Write DC Function, and the voltage to set to
			try waveformGeneratorInstrument?.write("SOURCE1:FUNCTION DC")
			try waveformGeneratorInstrument?.write("SOURCE1:VOLTAGE 5");
			
			// Turn the output on
			try waveformGeneratorInstrument?.write("OUTPUT1 ON")
		} catch {
			XCTFail()
		}
	}
	
	
	// Test the read by reading DC voltage. This also tests write too
	func testReadDCVoltage() {
		XCTAssertNotNil(multimeterInstrument)
		
		do {
			try multimeterInstrument?.write("MEASURE:VOLTAGE:DC?")
			let voltage = try multimeterInstrument?.read(as: Double.self)
			XCTAssertNotNil(voltage)
		} catch {
			XCTFail()
		}
	}
	
	// Test the functionality of the Query command by writing and reading a DC Voltage
	func testQuery() {
		XCTAssertNotNil(multimeterInstrument)
		
		do {
			let voltage = try multimeterInstrument?.query("MEASURE:VOLTAGE:DC?", as: Double.self)
			XCTAssertNotNil(voltage)
		} catch {
			XCTFail()
		}
	}
}
