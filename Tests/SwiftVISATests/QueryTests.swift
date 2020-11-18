//
//  QueryTests.swift
//  
//
//  Created by Connor Barnes on 11/18/20.
//

import XCTest
@testable import SwiftVISA

/// A series of tests to test the querying functionality of the library.
final class QueryTests: XCTestCase {
	/// Tests default querying functionality.
	func testQuery() {
		let instrument = MockInstrument()
		XCTAssertEqual(try! instrument.query("Test"), "Test")
		XCTAssertEqual(try! instrument.query("3.14", as: Double.self), 3.14, accuracy: 1e-10)
		XCTAssertEqual(try! instrument.query("-20", as: Int.self), -20)
		XCTAssertEqual(try! instrument.query("OFF", as: Bool.self), false)
	}
	/// Tests custom querying functionality.
	func testCustomDecoder() {
		let instrument = MockInstrument()
		
		struct LowercaseDecoder: MessageDecoder {
			typealias DecodingType = String
			
			func decode(_ message: String) throws -> String {
				return message.lowercased()
			}
		}
		
		let decoder = LowercaseDecoder()
		
		XCTAssertEqual(try! instrument.query("Some TEXT", as: String.self, using: decoder), "some text")
	}
	
	static var allTests = [
		("testQuery", testQuery),
	]
}
