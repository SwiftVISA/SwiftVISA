//
//  GPIBInterface.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/30/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

// TODO: Implement
public final class GPIBInterface: InstrumentProtocol {
	var _lockState: LockState
	
	public var session: Session
	
	public var identifier: String
	
	public var timeout: TimeInterval
	
	public var delegate: InstrumentDelegate?
	
	public init(session: Session, identifier: String) {
		#warning("Not implemented")
		fatalError("Not implemented")
	}
}
