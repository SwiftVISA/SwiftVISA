//
//  ConnectionTest.swift
//  SwiftVISA
//
//  Created by Avinash on 5/15/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

public struct Instrument {
	public var name: String
	
	public init(named name: String) {
		self.name = name
	}
}

extension Instrument {
	public var identification: String? {
		var resourceManager = ViSession()
		var instrumentSession = ViSession()
		guard viOpenDefaultRM(&resourceManager) >= VI_SUCCESS else {
			return nil
		}
		
		defer {
			viClose(resourceManager)
		}
		
		guard viOpen(resourceManager, name, ViAccessMode(VI_NULL), ViAccessMode(VI_NULL), &instrumentSession) >= VI_SUCCESS else {
			return nil
		}
		
		defer {
			viClose(instrumentSession)
		}
		
		guard viSetAttribute(instrumentSession, ViAttr(VI_ATTR_TMO_VALUE), 5000) >= VI_SUCCESS else {
			return nil
		}
		
		var returnCount = ViUInt32()
		guard viWrite(instrumentSession, "*IDN?\n", 6, &returnCount) >= VI_SUCCESS else {
			return nil
		}
		
		let capacity = 200
		let buffer = ViPBuf.allocate(capacity: capacity)
		guard viRead(instrumentSession, buffer, ViUInt32(capacity), &returnCount) >= VI_SUCCESS else {
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
		let endIndex = string.index(startIndex, offsetBy: String.IndexDistance(60))
		return String(string[startIndex..<endIndex])
	}
}
