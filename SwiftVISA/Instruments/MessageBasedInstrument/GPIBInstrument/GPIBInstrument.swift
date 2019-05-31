//
//  GPIBInstrument.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/30/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

// TODO: Implement
public final class GPIBInstrument: MessageBasedInstrument, InstrumentProtocol {
	var _lockState: LockState
	
	public var bufferSize: Int
	
	public var buffer: UnsafeMutableRawBufferPointer
	
	public var session: Session
	
	public var identifier: String
	
	public var beforeClose: () -> Void
	
	public var timeout: TimeInterval
	
	public init(session: Session, identifier: String) {
		#warning("Not implemented")
		fatalError("Not implemented")
	}
}