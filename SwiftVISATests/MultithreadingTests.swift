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
	func testWaveform() {
		guard let instrument = try? InstrumentManager.default?.makeInstrument(identifier: "USB0::0x0957::0x2607::MY52200879::INSTR") as? MessageBasedInstrument else {
			XCTFail()
			return
		}
		
		try? instrument.write("SOURCE1:FUNCTION DC")
		try? instrument.write("OUTPUT1 ON")
		
		var done = false
		
		instrument.dispatchQueue.async {
			print("Starting Async")
			
			for _ in 0...10 {
				print("Do Something")
				try? instrument.write("SOURCE1:VOLTAGE:OFFSET 0.5")
//				let firstValue = try? instrument.read(as: Double.self)
//				print(firstValue ?? "nil")
				usleep(1_000_000)
				try? instrument.write("SOURCE1:VOLTAGE:OFFSET 1.0")
//				let secondValue = try? instrument.read(as: Double.self)
//				print(secondValue ?? "nil")
				usleep(1_000_000)
			}
			
			print("Ending Async")
			done = true
		}
		
		while !done {
			usleep(1_000)
		}
		
	}
}
