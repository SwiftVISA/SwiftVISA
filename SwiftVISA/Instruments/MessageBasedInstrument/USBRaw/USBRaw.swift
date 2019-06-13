//
//  USBRaw.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/30/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

// TODO: Implement
public final class USBRaw: MessageBasedInstrument, InstrumentProtocol {
	static var _events: [UInt] = [VI_EVENT_USB_INTR]
	
	var _lockState: LockState
	
	public var bufferSize: Int
	
	public var buffer: UnsafeMutableRawBufferPointer
	
	public var session: Session
	
	public var identifier: String
	
	public var timeout: TimeInterval
	
//	public var delegate: InstrumentDelegate?
	
	public var dispatchQueue: DispatchQueue
	
	public init(session: Session, identifier: String) {
		bufferSize = 20480
		buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: bufferSize, alignment: 4096)
		self.session = session
		self.identifier = identifier
		_lockState = .unlocked
		timeout = 5.0
		dispatchQueue = DispatchQueue(label: identifier, qos: .userInitiated)
	}
	
	public func getIOProtocol() throws -> IOProtocol {
		return try IOProtocol(getAttribute(VI_ATTR_IO_PROT, as: UInt16.self))
	}
	
	public func setIOProtocol(ioProtocol: IOProtocol) throws {
		return try setAttribute(VI_ATTR_IO_PROT, value: Int(ioProtocol.protoCode))
	}
	
	public func getProductID() throws -> UInt16 {
		return try getAttribute(VI_ATTR_MODEL_CODE, as: UInt16.self)
	}
	
	public func getModelName() throws -> String {
		return try getAttribute(VI_ATTR_MODEL_NAME, as: String.self)
	}
}
