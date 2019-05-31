//
//  USBInstrument.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/30/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

// TODO: Implement
public final class USBInstrument: MessageBasedInstrument {
	public var bufferSize: Int
	
	public var buffer: UnsafeMutableRawBufferPointer
	
	public var session: Session
	
	public var uniqueIdentifier: String
	
	public var beforeClose: () -> Void
	
	public var lockState: LockState
	
	public var timeout: TimeInterval
	
	public init(session: Session) {
		bufferSize = 20480
		buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: bufferSize, alignment: 4096)
		self.session = session
		// TODO: What is uniqueIdentifier, why can it not be nil?
		uniqueIdentifier = ""
		// TODO: Why can beforeClose not be nil, maybe this should be moved to a delegate?
		beforeClose = { }
		lockState = .unlocked
		timeout = 5.0
	}
}
