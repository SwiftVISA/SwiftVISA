//
//  TCPIPSocket.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/30/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//
import CVISA
// TODO: Implement
final class TCPIPSocket: MessageBasedInstrument, InstrumentProtocol {
	// TODO: What NI-VISA resource does this correspond to?
	static var _events: [UInt] = []
	
	var _lockState: LockState
	
	public var bufferSize: Int
	
	public var buffer: UnsafeMutableRawBufferPointer
	
	public var session: Session
	
	public var identifier: String
	
	public var timeout: TimeInterval
	
//	public var delegate: InstrumentDelegate?
	
	public var dispatchQueue: DispatchQueue
	
	public init(session: Session, identifier: String) {
		#warning("Not implemented")
		fatalError("Not implemented")
	}
	
	public func getIOProtocol() throws -> IOProtocol {
		return try IOProtocol(getAttribute(VI_ATTR_IO_PROT, as: UInt16.self))
	}
	
	public func setIOProtocol(ioProtocol: IOProtocol) throws {
		return try setAttribute(VI_ATTR_IO_PROT, value: Int(ioProtocol.protoCode))
	}
}
