//
// Created by Avinash on 2019-05-28.
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
        try? multimeterInstrument?.close()
        try? waveformGeneratorInstrument?.close()
    }

	// Test the write command by setting the waveform characteristics
	func testSetWaveformCharacteristics() {
        // Write DC Function, and the voltage to set to
        try? waveformGeneratorInstrument?.write("SOURCE1:FUNCTION DC")
        try? waveformGeneratorInstrument?.write("SOURCE1:VOLTAGE:OFFSET 2.5");

        // Turn the output on
        try? waveformGeneratorInstrument?.write("OUTPUT1 ON")
	}
	
	
	// Test the read by reading DC voltage. This also tests write too
	func testReadDCVoltage() {
		try? multimeterInstrument?.write("MEASURE:SCALAR:VOLTAGE:DC?")
		let voltage = try? multimeterInstrument?.read(as: Double.self)
		print(voltage ?? "Nothing returned")

		XCTAssertNotNil(voltage)
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
    
    func testGetAttribute() {
        let manufacture = try? waveformGeneratorInstrument?.getAttribute(UInt32(VI_ATTR_MANF_NAME), as: String.self)
		
		let timeout = try? waveformGeneratorInstrument?.getAttribute(UInt32(VI_ATTR_TMO_VALUE), as: Int32.self)

        XCTAssertNotNil(manufacture)
		XCTAssertNotNil(timeout)
        XCTAssertEqual(manufacture, "Agilent Technologies")
		XCTAssertEqual(timeout, 2000)
    }
    
    func testSetAttribute() {
        XCTAssertNoThrow(try waveformGeneratorInstrument?.setAttribute(UInt32(VI_ATTR_TMO_VALUE), value: 90000))
        let timeout = try! waveformGeneratorInstrument?.getAttribute(UInt32(VI_ATTR_TMO_VALUE), as: Int32.self)

        print(timeout!)
        XCTAssertNotNil(timeout)
        XCTAssertEqual(timeout, 0)
    }

    // Test sending a trigger to the instrument
    func testAssertTrigger() {
        // XCTAssertNoThrow(try waveformGeneratorInstrument?.assertTrigger())
    }
}
