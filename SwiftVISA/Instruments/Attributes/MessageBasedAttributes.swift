//
//  MessageBasedAttributes.swift
//  SwiftVISA
//
//  Created by visaman on 5/29/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

extension MessageBasedInstrument {
	
	
	/// Sets the VISA buffer size for read operations
	///
	/// - Parameter size: The size of the buffer
	/// - Throws: <#throws value description#>
	func setReadBufferSize(size: UInt32) throws {
		let status = viSetBuf(session.viSession, UInt16(VI_READ_BUF), size)
		if status < VI_SUCCESS {
			throw VISAError(status)
		}
	}
	
	
	/// Gets the VISA buffer size for read operations
	///
	/// - Returns: <#return value description#>
	/// - Throws: <#throws value description#>
	func getReadBufferSize() throws -> UInt32 {
		return try getAttribute(VI_ATTR_RD_BUF_SIZE, as: UInt32.self)
	}
	
	/// Sets whether we should flush the read buffer on access
	/// VISA low level: Sets VI_ATTR_RD_BUF_OPER_MODE to VI_FLUSH_ON_ACCESS or VI_FLUSH_DISABLE
	/// - Parameter shouldFlush: <#shouldFlush description#>
	/// - Throws: <#throws value description#>
	func setShouldFlushReadOnAccess(shouldFlush: Bool) throws {
		if shouldFlush {
			try setAttribute(VI_ATTR_RD_BUF_OPER_MODE, value: Int(VI_FLUSH_ON_ACCESS))
		} else {
			try setAttribute(VI_ATTR_RD_BUF_OPER_MODE, value: Int(VI_FLUSH_DISABLE))
		}
	}
	
	/// Gets if the device is set to flush the read buffer on access
	/// VISA low level: Associated with VI_ATTR_RD_BUF_OPER_MODE and if it is set to VI_FLUSH_ON_ACCESS
	/// - Returns: Returns whether or not the read buffer operation mode is set to flush on access
	/// - Throws: <#throws value description#>
	func getShouldFlushOnAccess() throws -> Bool {
		return try getReadBufferOperatingMode() == VI_FLUSH_ON_ACCESS
	}
	
	/// Gets the VI_ATTR_RD_BUF_OPER_MODE; getShouldFlushOnAccess is recommended instead
	/// - Returns: The VISA code corresponding to either VI_FLUSH_ON_ACCESS or VI_FLUSH_DISABLE
	/// - Throws:
	func getReadBufferOperatingMode() throws -> UInt16 {
		return try getAttribute(VI_ATTR_RD_BUF_OPER_MODE, as: UInt16.self)
	}
	
	/// Sets the VISA buffer size for read operations
	///
	/// - Parameter size: The size of the buffer
	/// - Throws: <#throws value description#>
	func setWriteBufferSize(size: UInt32) throws {
		let status = viSetBuf(session.viSession, UInt16(VI_WRITE_BUF), size)
		if status < VI_SUCCESS {
			throw VISAError(status)
		}
	}
	
	
	/// Gets the VISA buffer size for write operations
	///
	/// - Returns: <#return value description#>
	/// - Throws: <#throws value description#>
	func getWriteBufferSize() throws -> UInt32 {
		return try getAttribute(VI_ATTR_WR_BUF_SIZE, as: UInt32.self)
	}
	
	/// Sets whether we should flush the write buffer when full (otherwise on access)
	/// VISA low level: Sets VI_ATTR_WR_BUF_OPER_MODE to VI_FLUSH_WHEN_FULL or VI_FLUSH_ON_ACCESS
	/// - Parameter shouldFlushWhenFull: Whether we should flush when full
	/// - Throws: <#throws value description#>
	func setShouldFlushWriteWhenFull(shouldFlushWhenFull: Bool) throws {
		if shouldFlushWhenFull {
			try setAttribute(VI_ATTR_WR_BUF_OPER_MODE, value: Int(VI_FLUSH_ON_ACCESS))
		} else {
			try setAttribute(VI_ATTR_WR_BUF_OPER_MODE, value: Int(VI_FLUSH_WHEN_FULL))
		}
	}
	
	/// Gets if the device is set to flush the read buffer on access
	/// VISA low level: Associated with VI_ATTR_RD_BUF_OPER_MODE and if it is set to VI_FLUSH_ON_ACCESS
	/// - Returns: Returns whether or not the read buffer operation mode is set to flush on access
	/// - Throws: <#throws value description#>
	func getShouldFlushWriteWhenFull() throws -> Bool {
		return try getWriteBufferOperatingMode() == VI_FLUSH_WHEN_FULL
	}
	
	/// Gets the VI_ATTR_WR_BUF_OPER_MODE; getShouldFlushWriteWhenFull is recommended instead
	/// - Returns: The VISA code corresponding to either VI_FLUSH_ON_ACCESS or VI_FLUSH_WHEN_FULL
	/// - Throws:
	func getWriteBufferOperatingMode() throws -> UInt16 {
		return try getAttribute(VI_ATTR_WR_BUF_OPER_MODE, as: UInt16.self)
	}
}
