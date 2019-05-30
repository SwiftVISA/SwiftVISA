//
//  PXIInstrument.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/30/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

public final class PXIInstrument: RegisterBasedInstrument {
	public var session: Session
	
	public var uniqueIdentifier: String
	
	public var beforeClose: () -> Void
	
	public var lockState: LockState
	
	public var timeout: TimeInterval
	
	public init() {
		#warning("Not implemented")
		fatalError("Not implemented")
	}
}
