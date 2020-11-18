//
//  File.swift
//  
//
//  Created by Connor Barnes on 11/17/20.
//

import XCTest
@testable import SwiftVISA

/// A series of tests to test the decoder functionality of the library.
class DecoderTests: XCTestCase {
	/// Tests the default string decoder.
	func testDefaultStringDecoder() {
		let decoder = DefaultStringDecoder()
		
		do {
			let expected = [
				"",
				"Some text",
				"\n\r\t\0\0\0\n\r TEXT \n\0\0\t \0 ",
				"1234",
				"3.14",
				"  ",
				"true",
				"false",
				"ON",
				"OFF"
			]
			
			try expected.forEach {
				XCTAssertEqual(try decoder.decode($0), $0)
			}
			
		} catch {
			// This method should never throw
			XCTFail()
		}
	}
	/// Tests the default integer decoder.
	func testDefaultIntDecoder() {
		let decoder = DefaultIntDecoder()
		
		// Conversions that should not fail
		do {
			let expected: [(String, Int)] = [
				("0", 0),
				("0000", 0),
				("512", 512),
				("-20", -20),
				(" 12", 12),
				("12 ", 12),
				(" 12 ", 12),
				("\r12\t\n ", 12),
				("1e4", 10_000),
				("3.14e2", 314)
			]
			
			try expected.forEach {
				XCTAssertEqual(try decoder.decode($0.0), $0.1)
			}
			
		} catch {
			XCTFail()
		}
		
		// Conversions that should fail with a specific error
		let longNumberString = String(repeating: "9", count: 10_000)
		
		let expectedErrors: [(String, DefaultIntDecoder.Error)] = [
			("", .notANumber),
			(longNumberString, .notInRange),
			("-" + longNumberString, .notInRange),
			("3.14", .notAnInteger),
			("2e-10", .notAnInteger),
			("1+1", .notANumber),
			("abc", .notANumber),
			("/n", .notANumber)
		]
		
		expectedErrors.forEach {
			do {
				_ = try decoder.decode($0.0)
				XCTFail()
			} catch {
				XCTAssertEqual(error as? DefaultIntDecoder.Error, $0.1)
			}
		}
	}
	/// Tests the default double decoder
	func testDefaultDoubleDecoder() {
		let decoder = DefaultDoubleDecoder()
		
		// Conversions that should not fail
		do {
			let expected: [(String, Double)] = [
				("1.0", 1.0),
				("1", 1.0),
				("01", 1.0),
				("3.14", 3.14),
				("-3.14", -3.14),
				(" 1", 1.0),
				("1 ", 1.0),
				(" 1 ", 1.0),
				("\n\t 1\r\n", 1.0),
				("1e3", 1e3),
				("1e+3", 1e+3),
				("1e-3", 1e-3),
				("-1e3", -1e3),
				("-1e+3", -1e+3),
				("-1e-3", -1e-3),
				("+1e3", +1e3),
				("+1e+3", +1e+3),
				("+1e-3", +1e-3),
				("inf", .infinity),
				("ninf", -.infinity),
				("-inf", -.infinity),
				("nan", .nan),
				("INF", .infinity),
				("NINF", -.infinity),
				("-INF", -.infinity),
				("NAN", .nan),
				("Inf", .infinity),
				("NInf", -.infinity),
				("-Inf", -.infinity),
				("NaN", .nan),
				("9.91e37", .nan),
				("9.9e37", .infinity),
				("-9.9e37", -.infinity)
			]
			
			try expected.forEach {
				if $0.1.isInfinite {
					let decoded = try decoder.decode($0.0)
					XCTAssert(decoded.isInfinite)
					XCTAssert($0.1.sign == decoded.sign)
				} else if $0.1.isNaN {
					XCTAssert(try decoder.decode($0.0).isNaN)
				} else {
					XCTAssertEqual(try decoder.decode($0.0), $0.1)
				}
			}
			
		} catch {
			XCTFail()
		}
		
		let expectedErrors: [(String, DefaultDoubleDecoder.Error)] = [
			("", .notANumber),
			("not a number", .notANumber),
			("abc", .notANumber),
			("3.1415-", .notANumber),
			("3.14 abc", .notANumber),
			("1e39", .notInRange),
			("-1e39", .notInRange)
		]
		
		expectedErrors.forEach {
			do {
				_ = try decoder.decode($0.0)
				XCTFail()
			} catch {
				XCTAssertEqual(error as? DefaultDoubleDecoder.Error, $0.1)
			}
		}
	}
	/// Tests the default boolean decoder.
	func testDefaultBoolDecoder() {
		let decoder = DefaultBoolDecoder()
		
		// Conversions that should not fail
		do {
			let expected: [(String, Bool)] = [
				("0", false),
				("0.0", false),
				("OFF", false),
				("off", false),
				("Off", false),
				("NO", false),
				("no", false),
				("nO", false),
				("false", false),
				("FALSE", false),
				("FAlse", false),
				(" 0", false),
				("0 ", false),
				("\t\r \n0 \r", false),
				("\t\r OFF\n", false),
				("1", true),
				("1.0", true),
				("ON", true),
				("on", true),
				("oN", true),
				("YES", true),
				("yes", true),
				("yEs", true),
				("true", true),
				("TRUE", true),
				("tRuE", true)
			]
			
			try expected.forEach {
				XCTAssertEqual(try decoder.decode($0.0), $0.1)
			}
			
		} catch {
			XCTFail()
		}
		
		// Conversions that should fail
		let expectedErrors: [(String, DefaultBoolDecoder.Error)] = [
			("", .notABoolean),
			("abc", .notABoolean),
			("21", .notABoolean),
			("11", .notABoolean),
			("1.00001", .notABoolean)
		]
		
		expectedErrors.forEach {
			do {
				_ = try decoder.decode($0.0)
				XCTFail()
			} catch {
				XCTAssertEqual(error as? DefaultBoolDecoder.Error, $0.1)
			}
		}
	}
	
	static var allTests = [
		("testDefaultStringDecoder", testDefaultStringDecoder),
		("testDefaultIntDecoder", testDefaultIntDecoder),
		("testDefaultDoubleDecoder", testDefaultDoubleDecoder),
		("testDefaultBoolDecoder", testDefaultBoolDecoder)
	]
}
