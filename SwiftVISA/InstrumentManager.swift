//
//  InstrumentManager.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/16/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

/// A class the encapsulates a VISA resource manager.
///
/// Instances of this class cannot be initialized directly. To access the default resource manager, use `InstrumentManager.default`.
class InstrumentManager {
	/// The session associated with the resource manager.
	var session: ViSession

	/// Creates an `InstrumentManager` from a `ViSession`.
	///
	/// - Parameter session: The VISA Session object.
	private init(session: ViSession) {
		self.session = session
	}

	/// After an instrument manager has been successfully initialized, it is stored here for future use.
	private static var _default: InstrumentManager?

	/// The shared instrument manager. If the instrument manager could not be created, this returns `nil`.
	static var `default`: InstrumentManager? {
		if let saved = _default {
			// If a instrument manager object has already been created, use that one rather than creating a new instrument manager
			return saved
		}

		// A instrument manager has not been created yet, try to create one
		var session = ViSession()
		let status = viOpenDefaultRM(&session)
		guard status >= VI_SUCCESS else {
			return nil
		}

		// Successfully created, store this object for future use
		let instrumentManager = InstrumentManager(session: session)
		_default = instrumentManager
		return instrumentManager
	}
}

// MARK: Make Instrument
extension InstrumentManager {
	public func makeInstrument(uii: String) throws -> Instrument {
		// TODO: Implement
		#warning("Not implemented")
		fatalError("Not implemented")
	}
}

// MARK: Close
extension InstrumentManager {
	/// Closes the instrument manager. Call this when you are finished with the instrument manager. Once this has been called, the instrument manager cannot be reopened.
	///
	/// - Throws: One of the following `VISAError` errors: `.invalidSession`, `.failedToClose`.
	public func close() throws {
		let status = viClose(session)
		guard status >= VI_SUCCESS else { throw VISAError(status) }
	}
}
