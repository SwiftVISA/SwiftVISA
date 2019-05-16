//
//  Instrument.swift
//  SwiftVISA
//
//  Created by Avinash on 5/15/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

/// An object that represents an instrument that can be communicated with.
public class Instrument {
	/// The name of the instrument.
	public let name: String
	/// The `ViSession` that represents the instrument.
	var session: ViSession
	
	/// Tries to create an instrument from a name.
	///
	/// - Parameters:
	///   - name: The name of the instrument.
	///   - timeout: The amount of time to wait for read and write operations before timing out.
	public init?(named name: String, timeout: TimeInterval = 5.0) {
		self.name = name
		session = ViSession()
		
		guard let resourceManager = ResourceManager.default else { return }
		
		guard viOpen(resourceManager.session, name, ViAccessMode(VI_NULL), ViAccessMode(VI_NULL), &session) >= VI_SUCCESS else {
			return nil
		}
		
		guard viSetAttribute(session, ViAttr(VI_ATTR_TMO_VALUE), ViAttrState(timeout * 1000)) >= VI_SUCCESS else {
			return nil
		}
	}
}

// MARK: Identification
extension Instrument {
	/// Returns the identification for the instrument.
	public var identification: String? {
		do {
			try visaWrite(to: self, "*IDN?\n")
			return try visaRead(from: self, bufferSize: 200)
		} catch {
			return nil
		}
	}
}

// MARK: Close
extension Instrument {
	/// Closes the connection to the instrument. Call this once you are done communicating to an instrument. After this is called you can no longer read from or write to the instrument.
	public func close() {
		viClose(session)
	}
}
