//
//  Instrument.swift
//  SwiftVISA
//
//  Created by Avinash on 5/15/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

public struct Instrument {
	public var name: String
	public var session: ViSession
	public init?(named name: String) {
		self.name = name
		
		var resourceManager = ViSession()
		session = ViSession()
		guard viOpenDefaultRM(&resourceManager) >= VI_SUCCESS else {
			return nil
		}
		
		defer {
			viClose(resourceManager)
		}
		
		guard viOpen(resourceManager, name, ViAccessMode(VI_NULL), ViAccessMode(VI_NULL), &session) >= VI_SUCCESS else {
			return nil
		}
		
		defer {
			viClose(session)
		}
		
		guard viSetAttribute(session, ViAttr(VI_ATTR_TMO_VALUE), 5000) >= VI_SUCCESS else {
			return nil
		}
		
	}
}

extension Instrument {
	public var identification: String? {
		
		var returnCount = ViUInt32()
		guard viWrite(session, "*IDN?\n", 6, &returnCount) >= VI_SUCCESS else {
			return nil
		}
		
		let capacity = 200
		let buffer = ViPBuf.allocate(capacity: capacity)
		guard viRead(session, buffer, ViUInt32(capacity), &returnCount) >= VI_SUCCESS else {
			return nil
		}
		
		let pointer = UnsafeRawPointer(buffer)
		let bytes = MemoryLayout<UInt8>.stride * capacity
		let data = Data(bytes: pointer, count: bytes)
		guard let string = String(data: data, encoding: .ascii) else {
			return nil
		}
		guard returnCount <= capacity && returnCount >= 0 else {
			return nil
		}
		let startIndex = string.startIndex
		let endIndex = string.index(startIndex, offsetBy: String.IndexDistance(returnCount))
		return String(string[startIndex..<endIndex])
	}
}
