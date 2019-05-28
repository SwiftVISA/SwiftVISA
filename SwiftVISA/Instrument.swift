//
//  Instrument.swift
//  SwiftVISA
//
//  Created by Avinash on 5/15/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

/// An object that represents an instrument that can be communicated with.
public protocol Instrument: class {
	var session: Session { get }
	var uniqueIdentifier: String { get }
	var beforeClose: () -> Void { get set }
	var lockState: LockState { get set }
	var timeout: TimeInterval { get set }
}

// MARK: Default Implementations
public extension Instrument {
	func clear() throws {
		let status = viClear(session.viSession)
		guard status >= VI_SUCCESS else { throw ClearError(status) ?? UnknownError() }
	}
	
	func close() throws {
		let status = viClose(session.viSession)
		guard status >= VI_SUCCESS else { throw CloseError(status) ?? UnknownError() }
	}
	
	func lock(_ type: LockState.LockType, timeout: TimeInterval) throws {
		
		// timeout is in seconds, convert to miliseconds
		let viTimeout = ViUInt32(timeout * 1000.0)
		
		switch type {
		case .exclusive:
			var null0 = ViChar(VI_NULL)
			var null1 = ViChar(VI_NULL)
			let status = viLock(session.viSession, 1, viTimeout, &null0, &null1)
			
			guard status >= VI_SUCCESS else { throw LockError(status) ?? UnknownError() }
			
			lockState = .locked(.exclusive)
		case .shared (let key):
			let asciiKey = key.filter { $0.isASCII }
			guard var cRequestedKey = asciiKey.cString(using: .ascii) else { throw LockError.invalidRequestKey }
			let capacity = min(256, asciiKey.count)
			let accessKeyBuffer = UnsafeMutableBufferPointer<ViChar>.allocate(capacity: capacity)
			
			let status = viLock(session.viSession, 2, viTimeout, &cRequestedKey, accessKeyBuffer.baseAddress!)
			
			guard status >= VI_SUCCESS else { throw LockError(status) ?? UnknownError() }
			
			let data = Data(buffer: accessKeyBuffer)
			guard let string = String(bytes: data, encoding: .ascii) else { throw LockError.invalidAccessKey }
			
			lockState = .locked(.shared(key: string))
		}
	}
	
	func unlock() throws {
		let status = viUnlock(session.viSession)
		
		// If the status was VI_ERROR_SESN_NLOCKED, the instrument was not locked, don't throw an error for this, just print out a warning.
		guard status >= VI_SUCCESS || status == VI_ERROR_SESN_NLOCKED else {
			throw LockError(status) ?? UnknownError()
		}
		
		if status == VI_ERROR_SESN_NLOCKED {
			print("WARNING: The instrument \"\(uniqueIdentifier)\" was not locked, but unlock() was called!")
		}
		
		lockState = .unlocked
	}
}

