//
//  TCPIPSocket.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/30/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

// TODO: Implement
public final class TCPIPSocket: MessageBasedInstrument, InstrumentProtocol {
	// TODO: What NI-VISA resource does this correspond to?
	static var _events: [UInt] = []
	
	var _lockState: LockState
	
	public var bufferSize: Int
	
	public var buffer: UnsafeMutableRawBufferPointer
	
	public var session: Session
	
	public var identifier: String
	
	public var timeout: TimeInterval
	
	public var delegate: InstrumentDelegate?
	
	public init(session: Session, identifier: String) {
		#warning("Not implemented")
		fatalError("Not implemented")
	}
}
