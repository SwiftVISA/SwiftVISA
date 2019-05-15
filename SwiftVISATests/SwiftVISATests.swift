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
	
	func testExample() {
		do {
			_ = try ResourceManager.openDefault()
		} catch {
			print(error)
		}
	}
	
	func testIdentification() {
		let instrument = Instrument(named: "USB0::0x0957::0x2607::MY52200879::INSTR")!
		let identification = instrument.identification
		print(identification ?? "nil")
	}
	
	func testVoltage() {
		let instrument = Instrument(named: "USB0::0x0957::0x2607::MY52200879::INSTR")!
		setVoltage(to: instrument.session, voltage: 0.0)
	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}
	
}
