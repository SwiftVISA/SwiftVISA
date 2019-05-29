//
//  Instrument.swift
//  SwiftVISA
//
//  Created by Avinash on 5/15/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

/// A type that can communicated with via VISA.
public protocol Instrument: class {
	/// The session associated with the instrument.
	var session: Session { get }
	/// A unique identifier for the instrument.
	var uniqueIdentifier: String { get }
	/// A completion handler that is ran before the instrument is closed.
	var beforeClose: () -> Void { get set }
	// TODO: Should this be moved to session? Should it be read-only? The setter is only used for the default implementation, but aside from that, this should never be set by the user.
	/// The lock state for the instrument.
	var lockState: LockState { get set }
	/// The time in seconds to wait before timing out when performing operations with the instrument.
	var timeout: TimeInterval { get set }
}

// MARK: Default Implementations
public extension Instrument {
	/// Performs an IEEE-488.1-style clear of the device.
	///
	/// - Throws: One of the following `VISAError` errors: `.invalidSession`, `.unsupportedOperation`, `.resourceLocked`, `.timeout`, `.rawWriteProtocolViolation`, `.rawReadProtocolViolation`, `.busError`, `.notControllerInCharge`, `.noListeners`, `.invalidSetup`, `.connectionLost`.
	func clear() throws {
		let status = viClear(session.viSession)
		guard status >= VI_SUCCESS else { throw VISAError(status) }
	}
	
	// TODO: Should this method be renamed? The close function makes more sense with session objects, but perhaps should be renamed to something else for instruments.
	/// Closes the specified insturment. After the instrument has been closed, no more operations can be performed with the instrument.
	///
	/// - Throws: One of the following `VISAError` errors: `.invalidSession`, `.failedToClose`.
	func close() throws {
		let status = viClose(session.viSession)
		guard status >= VI_SUCCESS else { throw VISAError(status) }
	}
}
