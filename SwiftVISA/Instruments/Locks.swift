//
//  Locks.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/28/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

/// The lock state of an instrument.
///
/// - locked: The instrument is locked with the given lock type.
/// - unlocked: The instrument is unlocked.
public enum LockState {
	case locked (LockType)
	case unlocked
	
	/// The type of lock on an instrument.
	///
	/// - shared: The instrument can be accessed by any session with the access key that was generated by the session that locked the instrument. The shared key that is used for this resource is stored in `key`.
	/// - exclusive: The instrument can only be accessed by the session that locked the instrument.
	public enum LockType {
		case shared (key: String)
		case exclusive
	}
}

// MARK: Instrument Default Implementations
public extension Instrument {
	// TODO: Should the timeout value just use the instrument's timeout property instead of taking it as an argument?
	/// Locks the instrument with the specified lock type and timeout.
	///
	/// - Parameters:
	///   - type: The lock type to use.
	///   - timeout: The time in seconds to wait before timing out.
	/// - Throws: One of the following `VISAError` errors: `.invalidSession`, `.resourceLocked`, `.invalidLockType`, `.invalidAccessKey`, `.timeout`.
	/// - Note: Locks can be nested.
	func lock(_ type: LockState.LockType, timeout: TimeInterval) throws {
		// timeout is in seconds, convert to miliseconds
		let viTimeout = ViUInt32(timeout * 1000.0)
		
		switch type {
		case .exclusive:
			var null0 = ViChar(VI_NULL)
			var null1 = ViChar(VI_NULL)
			let status = viLock(session.viSession, 1, viTimeout, &null0, &null1)
			
			guard status >= VI_SUCCESS else { throw VISAError(status) }
			
			lockState = .locked(.exclusive)
		case .shared (let key):
			let asciiKey = key.filter { $0.isASCII }
			guard var cRequestedKey = asciiKey.cString(using: .ascii) else { throw VISAError.invalidRequestKey }
			let capacity = min(256, asciiKey.count)
			let accessKeyBuffer = UnsafeMutableBufferPointer<ViChar>.allocate(capacity: capacity)
			
			let status = viLock(session.viSession, 2, viTimeout, &cRequestedKey, accessKeyBuffer.baseAddress!)
			
			guard status >= VI_SUCCESS else { throw VISAError(status) }
			
			let data = Data(buffer: accessKeyBuffer)
			guard let string = String(bytes: data, encoding: .ascii) else { throw VISAError.invalidAccessKey }
			
			lockState = .locked(.shared(key: string))
		}
	}
	
	/// Unlocks the instrument if it is locked.
	///
	/// - Throws: One of the following `VISAError` errors: `.invalidSession`, `.sessionNotLocked`
	/// - Note: Locks can be nested.
	func unlock() throws {
		let status = viUnlock(session.viSession)
		
		// If the status was VI_ERROR_SESN_NLOCKED, the instrument was not locked, don't throw an error for this, just print out a warning.
		guard status >= VI_SUCCESS || status == VI_ERROR_SESN_NLOCKED else {
			throw VISAError(status)
		}
		
		if status == VI_ERROR_SESN_NLOCKED {
			print("WARNING: The instrument \"\(uniqueIdentifier)\" was not locked, but unlock() was called!")
		}
		
		lockState = .unlocked
	}
}