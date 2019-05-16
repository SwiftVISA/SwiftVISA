//
//  SwiftVISATests.swift
//  SwiftVISATests
//
//  Created by Avinash on 5/14/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import XCTest
@testable import SwiftVISA

class SwiftVISATests: XCTestCase {
	
	override func setUp() {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testIdentification() {
		let instrument = Instrument(named: "USB0::0x0957::0x2607::MY52200879::INSTR")
		XCTAssertNotNil(instrument)
		let identification = instrument?.identification
		XCTAssertNotNil(identification)
	}
	
	func testVoltage() {
		guard let instrument = Instrument(named: "USB0::0x0957::0x2607::MY52200879::INSTR") else {
			XCTFail()
			return
		}
		XCTAssertNoThrow(try setVoltage(to: instrument, voltage: 7.0))
	}
	
	func testReadVoltage() {
		guard let instrument = Instrument(named: "USB0::0x0957::0x1A07::MY53205040::0::INSTR") else {
			XCTFail()
			return
		}
		let voltage = try? readVoltage(from: instrument)
		XCTAssertNotNil(voltage)
	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}
	
}
