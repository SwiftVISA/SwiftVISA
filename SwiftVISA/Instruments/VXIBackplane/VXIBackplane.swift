//
//  VXIBackplane.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/30/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

// TODO: Implement
public final class VXIBackplane: InstrumentProtocol {
	static var _events: [UInt] = [VI_EVENT_TRIG,
																VI_EVENT_VXI_VME_SYSFAIL,
																VI_EVENT_VXI_VME_SYSRESET]
	
	var _lockState: LockState
	
	public var session: Session
	
	public var identifier: String
	
	public var timeout: TimeInterval
	
	public var delegate: InstrumentDelegate?
	
	public var dispatchQueue: DispatchQueue
	
	public init(session: Session, identifier: String) {
		#warning("Not implemented")
		fatalError("Not implemented")
	}
}
