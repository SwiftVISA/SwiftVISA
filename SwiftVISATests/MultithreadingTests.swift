//
//  MultithreadingTests.swift
//  SwiftVISATests
//
//  Created by Connor Barnes on 6/10/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import XCTest
@testable import SwiftVISA
import CVISA

class MultithreadingTests: XCTestCase {
	let waitTime = 10_000
	
	func testWaveform() {
		guard let instrument = try? InstrumentManager.default?.makeInstrument(identifier: "USB0::0x0957::0x2607::MY52200879::INSTR") as? MessageBasedInstrument else {
			XCTFail()
		}
		
		try? instrument.write("SOURCE1:FUNCTION DC")
		try? instrument.write("OUTPUT1 ON")
		
		
		try? instrument.write("SOURCE1:VOLTAGE:OFFSET 2.5")
		
	}
}
