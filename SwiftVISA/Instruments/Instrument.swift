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
	/// A completion handler that is ran before the instrument is closed.
	var beforeClose: () -> Void { get set }
	// TODO: Should this be moved to session? Should it be read-only? The setter is only used for the default implementation, but aside from that, this should never be set by the user.
	/// The time in seconds to wait before timing out when performing operations with the instrument.
	var timeout: TimeInterval { get set }
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
		let status = viClose(session.viSession)
		guard status >= VI_SUCCESS else { throw VISAError(status) }
	}
    
    /// Gets the given NI-VISA attribute on the instrument
    ///
    /// - Throws: ???
    func getAttribute(_ attributeId: ViAttr) throws -> String{
        let buffer = ViPBuf.allocate(capacity: 2048)
        let status = viGetAttribute(session.viSession, attributeId, buffer)
    
        guard status >= VI_SUCCESS else { throw VISAError(status) }
        // convert the data to a readable string format
        let pointer = UnsafeRawPointer(buffer)
        let bytes = MemoryLayout<UInt8>.stride * 2048
        let data = Data(bytes: pointer, count: bytes)
        guard let string = String(data: data, encoding: .ascii) else {
            throw VISAError.couldNotDecode
        }
        let startIndex = string.startIndex
        guard let endIndex = string.firstIndex(of: "\0") else {
            // TODO remove this print when "rigorous" testing done
            print("Buffer size bad (null byte not found) D:")
            throw VISAError.couldNotDecode
        }
        return String(string[startIndex..<endIndex])
    }
    
    /// sets the given NI-VISA attribute on the instrument
    ///
    /// - Throws: ???
    func setAttibute(_ attributeId: ViAttr, value: String) throws {
        // TODO make sure that attribute responses are never greater than 2048 bytes
        let buffer = ViPBuf.allocate(capacity: 2048)
        
        // let status = viSetAttribute(session.viSession, attributeId, value)
        // guard status >= VI_SUCCESS else { throw VISAError(status)}
    }
}
