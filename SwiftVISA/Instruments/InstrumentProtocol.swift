//
//  InstrumentProtocol.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/30/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

/// This is an internal helper protocol for adding functionality to instruments.
protocol InstrumentProtocol: Instrument {
	/// The lock state for the instrument.
	var _lockState: LockState { get set }
	/// The events associated with the instrument
	static var _events: [UInt] { get }
	
	init(session: Session, identifier: String)
}

extension Instrument {
	/// The current lock state of the instrument.
	var lockState: LockState {
		guard let self = self as? InstrumentProtocol else { fatalError("Invalid instrument class") }
		return self._lockState
	}
}
