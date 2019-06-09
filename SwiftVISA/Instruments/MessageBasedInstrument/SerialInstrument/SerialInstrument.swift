//
//  SerialInstrument.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/30/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

// TODO: Implement
public final class SerialInstrument: MessageBasedInstrument, InstrumentProtocol {
	static var _events: [UInt] = [VI_EVENT_ASRL_BREAK,
																VI_EVENT_ASRL_CHAR,
																VI_EVENT_ASRL_CTS,
																VI_EVENT_ASRL_DCD,
																VI_EVENT_ASRL_DSR,
																VI_EVENT_ASRL_RI,
																VI_EVENT_ASRL_TERMCHAR]
	
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
