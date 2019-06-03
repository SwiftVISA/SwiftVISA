//
//  InstrumentProtocol.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/30/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

/// This is an internal helper protocol for adding functionality to instruments.
protocol InstrumentProtocol: Instrument {
	/// The lock state for the instrument.
	var _lockState: LockState { get set }
	
	init(session: Session, identifier: String)
}

public extension Instrument {
	/// The current lock state of the instrument.
	var lockState: LockState {
		guard let self = self as? InstrumentProtocol else { fatalError("Invalid instrument class") }
		return self._lockState
	}
}
