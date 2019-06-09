//
//  USBRaw.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/30/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

// TODO: Implement
public final class USBRaw: MessageBasedInstrument, InstrumentProtocol {
	var _lockState: LockState
	
	public var bufferSize: Int
	
	public var buffer: UnsafeMutableRawBufferPointer
	
	public var session: Session
	
	public var identifier: String
	
	public var beforeClose: () -> Void
	
	public var timeout: TimeInterval
	
	public init(session: Session, identifier: String) {
        bufferSize = 20480
        buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: bufferSize, alignment: 4096)
        self.session = session
        self.identifier = identifier
        // TODO: Why can beforeClose not be nil, maybe this should be moved to a delegate?
        beforeClose = { }
        _lockState = .unlocked
        timeout = 5.0
	}
}
