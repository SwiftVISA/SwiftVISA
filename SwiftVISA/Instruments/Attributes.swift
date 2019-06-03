//
//  Attributes.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 6/3/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

extension Instrument {
	/// sets the given NI-VISA attribute on the instrument
	///
	/// - Throws: ???
	func setAttibute(_ attributeId: ViAttr, value: String) throws {
		// TODO make sure that attribute responses are never greater than 2048 bytes
		let buffer = ViPBuf.allocate(capacity: 2048)
		
		// let status = viSetAttribute(session.viSession, attributeId, value)
		// guard status >= VI_SUCCESS else { throw VISAError(status)}
	}
}
