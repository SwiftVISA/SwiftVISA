//
//  GPIBInterface.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/30/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

// TODO: Implement
final class GPIBInterface: InstrumentProtocol {
	static var _events: [UInt] = [VI_EVENT_CLEAR,
																VI_EVENT_GPIB_CIC,
																VI_EVENT_GPIB_LISTEN,
																VI_EVENT_GPIB_TALK,
																VI_EVENT_SERVICE_REQ,
																VI_EVENT_TRIG]
	
	var _lockState: LockState
	
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
