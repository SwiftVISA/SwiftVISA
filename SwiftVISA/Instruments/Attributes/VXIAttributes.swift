//
//  VXIAttributes.swift
//  SwiftVISA
//
//  Created by visaman on 6/11/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//
import CVISA

public extension VXIInstrument {
	func getIOProtocol() throws -> IOProtocol {
		return try IOProtocol(getAttribute(VI_ATTR_IO_PROT, as: UInt16.self))
	}
	
	func setIOProtocol(ioProtocol: IOProtocol) throws {
		return try setAttribute(VI_ATTR_IO_PROT, value: Int(ioProtocol.protoCode))
	}
	
	func getModelCode() throws -> UInt16 {
		return try getAttribute(VI_ATTR_MODEL_CODE, as: UInt16.self)
	}
	
	func getModelName() throws -> String {
		return try getAttribute(VI_ATTR_MODEL_NAME, as: String.self)
	}
	
	func getIs4882Compliant() throws -> Bool {
		return try getAttribute(VI_ATTR_4882_COMPLIANT, as: Bool.self)
	}
}
