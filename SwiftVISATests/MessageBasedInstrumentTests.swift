//
// Created by the SwiftVISA team on 2019-05-28.
// Copyright (c) 2019 SwiftVISA. All rights reserved.
//

import XCTest
@testable import SwiftVISA
import CVISA

/// This class tests MessageBasedInstrument by running tests against and agilent
class MessageBasedInstrumentTests : XCTestCase {
	var multimeterInstrument: MessageBasedInstrument?
	var waveformGeneratorInstrument: MessageBasedInstrument?
	var multimeterUII: String = "USB0::0x0957::0x1A07::MY53205040::0::INSTR"
	var waveformGeneratorUUI: String = "USB0::0x0957::0x2607::MY52200879::INSTR"
	
	// Start the session to all the instruments
	override func setUp() {
		guard let im = InstrumentManager.default else { return }
		multimeterInstrument = try? im.makeInstrument(identifier: multimeterUII) as? MessageBasedInstrument
		waveformGeneratorInstrument = try? im.makeInstrument(identifier: waveformGeneratorUUI) as? MessageBasedInstrument
		
		// Ensure we connected to the instruments
		XCTAssertNotNil(waveformGeneratorInstrument)
		XCTAssertNotNil(multimeterInstrument)
	}
	
	// Remove all the sessions
	override func tearDown() {
		try? waveformGeneratorInstrument?.setAttribute(VI_ATTR_TMO_VALUE, value: 2000)
		try? multimeterInstrument?.close()
		try? waveformGeneratorInstrument?.close()
	}
	
	// Test the write command by setting the waveform characteristics
	func testSetWaveformCharacteristics() {
		// Write DC Function, and the voltage to set to
		try? waveformGeneratorInstrument?.write("SOURCE1:FUNCTION DC")
		try? waveformGeneratorInstrument?.write("SOURCE1:VOLTAGE:OFFSET 2.5")
		
		// Turn the output on
		try? waveformGeneratorInstrument?.write("OUTPUT1 ON")
	}
	
	
	// Test the read by reading DC voltage. This also tests write too
	func testReadDCVoltage() {
		try? multimeterInstrument?.write("MEASURE:SCALAR:VOLTAGE:DC?")
		let voltage = try? multimeterInstrument?.read(as: Double.self)
		
		XCTAssertNotNil(voltage)
	}
	
	// Test the readRaw function
	func testReadRaw() {
		try? multimeterInstrument?.write("MEASURE:SCALAR:VOLTAGE:DC?")
		// Verify we got a voltage
		guard let voltage = try? multimeterInstrument?.readRaw() else {
			XCTFail()
			return
		}
		
		XCTAssert(voltage.last == "\n" || voltage.last == "\0") // Verify there is a termination character
	}
	
	// Test the functionality of the Query command by writing and reading a DC Voltage
	func testQuery() {
		let voltage = try? multimeterInstrument?.query("MEASURE:SCALAR:VOLTAGE:DC?", as: Double.self)
		XCTAssertNotNil(voltage)
	}
	
	// A query that waits between the write/read
	func testDelayedQuery() {
		let voltage = try? multimeterInstrument?.query("MEASURE:SCALAR:VOLTAGE:DC?", as: Double.self, readDelay: 0.5)
		XCTAssertNotNil(voltage)
	}
	
	// Test querying 10 times at once.
	func testMultipleReadQuery() {
		let voltage = try? multimeterInstrument?.query("MEASURE:VOLTAGE:DC?", as: Double.self, numberOfReads: 10)
		
		// Assert we got 10 back
		XCTAssertNotNil(voltage)
		XCTAssertEqual(voltage?.count, 10)
	}
	
	// Test getting attributes
	func testGetAttribute() {
		let manufacture = try? waveformGeneratorInstrument?.getAttribute(VI_ATTR_MANF_NAME, as: String.self)
		
		let timeout = try? waveformGeneratorInstrument?.getAttribute(VI_ATTR_TMO_VALUE, as: Int32.self)
		
		XCTAssertNotNil(manufacture)
		XCTAssertNotNil(timeout)
		XCTAssertEqual(manufacture, "Agilent Technologies")
		XCTAssertEqual(timeout, 2000)
	}
	
	// Test setting attributes
	func testSetAttribute() {
		XCTAssertNoThrow(try waveformGeneratorInstrument?.setAttribute(VI_ATTR_TMO_VALUE, value: 3000))
		let timeout = try! waveformGeneratorInstrument?.getAttribute(VI_ATTR_TMO_VALUE, as: Int32.self)
		
		XCTAssertNotNil(timeout)
		XCTAssertEqual(timeout, 3000)
	}
	
	// Tests sending a trigger to the devices
	func testAssertTrigger() {
		XCTAssertNoThrow(try multimeterInstrument?.assertTrigger())
		XCTAssertNoThrow(try waveformGeneratorInstrument?.assertTrigger())
	}
	
	// Test reading the status byte, STB
	func testSTB() {
		let STB = try? multimeterInstrument?.readStatusByte()
		
		XCTAssertNotNil(STB)
	}
}
