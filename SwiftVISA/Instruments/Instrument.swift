//
//  Instrument.swift
//  SwiftVISA
//
//  Created by Avinash on 5/15/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

//  TODO: should beforeClose() be removed? It is very uncommon to have a type store a closure like this. If we would like to keep its functionality, we could move it a delegate?
/// A type that can communicated with via VISA.
public protocol Instrument: class {
	/// The session associated with the instrument.
	var session: Session { get }
	/// A unique identifier for the instrument.
	var identifier: String { get }
	
	// TODO: Should this be moved to session? Should it be read-only? The setter is only used for the default implementation, but aside from that, this should never be set by the user.
	/// The time in seconds to wait before timing out when performing operations with the instrument.
	var timeout: TimeInterval { get set }
	/// The delegate for the instrument – used for managing events.
	var delegate: InstrumentDelegate? { get }
	/// The instrument's dispatch queue that allows for running instrument code on another thread. Each instrument has a unique dispatch queue.
	///
	/// It is reccomended to run all code that interfaces with the instrument on this dispatch queue to prevent blocking the main thread when reading/writing data to/from the instrument. Doing so will prevent GUI hangs and also allows for communicating with multiple instruments at the same time. If one or more instruments need to wait on another instrument before doing work, you can run the code for the instruments on a single instrument's dispatch queue.
	var dispatchQueue: DispatchQueue { get }
}

// MARK: Default Implementations
public extension Instrument {
	/// Performs an IEEE-488.1-style clear of the device.
	///
	/// - Throws: One of the following `VISAError` errors:
	///   - `.invalidSession`
	///   - `.unsupportedOperation`
	///   - `.resourceLocked`
	///   - `.timeout`
	///   - `.rawWriteProtocolViolation`
	///   - `.rawReadProtocolViolation`
	///   - `.busError`
	///   - `.notControllerInCharge`
	///   - `.noListeners`
	///   - `.invalidSetup`
	///   - `.connectionLost`
	func clear() throws {
		#warning("Not unit tested")
		let status = viClear(session.viSession)
		guard status >= VI_SUCCESS else { throw VISAError(status) }
	}
	
	// TODO: Should this method be renamed? The close function makes more sense with session objects, but perhaps should be renamed to something else for instruments.
	/// Closes the specified insturment. After the instrument has been closed, no more operations can be performed with the instrument.
	///
	/// - Throws: One of the following `VISAError` errors:
	///   - `.invalidSession`
	///   - `.failedToClose`
	func close() throws {
		#warning("Not unit tested")
		let status = viClose(session.viSession)
		guard status >= VI_SUCCESS else { throw VISAError(status) }
	}
}
