//
//  TCPIPInstrument.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/29/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

// TODO: Implement
final class TCPIPInstrument: MessageBasedInstrument, InstrumentProtocol {
	static var _events: [UInt] = [VI_EVENT_SERVICE_REQ]
	
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
}
