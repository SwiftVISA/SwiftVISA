//
//  MockInstrument.swift
//  
//
//  Created by Connor Barnes on 11/17/20.
//

import SwiftVISA
@testable import CoreSwiftVISA
import Foundation

/// A mock instrument for testing.
///
/// The instrument will alwauys return the last sent message when `read` is called. If `read` is called before `write` is called, then `read` will return an empty string.
class MockInstrument: MessageBasedInstrument {
	/// The last message written to the instrument.
	var lastMessage: String = ""
	
	func writeBytes(_: Data, appending terminator: Data?) throws {
		fatalError("Not implemented")
	}

	func write(_ string: String, appending terminator: String?, encoding: String.Encoding) throws {
		self.lastMessage = string
	}

	func readBytes(maxLength: Int?, until terminator: Data, strippingTerminator: Bool, chunkSize: Int) throws -> Data {
		fatalError("Not implemented")
	}

	func readBytes(length: Int, chunkSize: Int) throws -> Data {
		fatalError("Not implemented")
	}

	func read(until terminator: String, strippingTerminator: Bool, encoding: String.Encoding, chunkSize: Int) throws -> String {
		return lastMessage
	}

	var attributes: InstrumentAttributes = InstrumentAttributes()
}
