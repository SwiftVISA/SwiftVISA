//
//  VXIAttributes.swift
//  SwiftVISA
//
//  Created by visaman on 6/11/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//
import CVISA

public extension VXIInstrument {
	/// Gets the IO protocol in use by the serial instrument (VI_ATTR_IO_PROT)
	///
	/// - Returns: The IO protocol in use
	/// - Throws: <#throws value description#>
	func getIOProtocol() throws -> IOProtocol {
		return try IOProtocol(getAttribute(VI_ATTR_IO_PROT, as: UInt16.self))
	}
	
	/// Sets the IO protocol in use by the serial instrument (VI_ATTR_IO_PROT)
	///
	/// - Parameter ioProtocol: The IO protocol to use
	/// - Throws: <#throws value description#>
	func setIOProtocol(ioProtocol: IOProtocol) throws {
		return try setAttribute(VI_ATTR_IO_PROT, value: Int(ioProtocol.protoCode))
	}
	
	/// Gets the model code for the device (VI_ATTR_MODEL_CODE)
	///
	/// - Returns: The model code for the device
	/// - Throws: <#throws value description#>
	func getModelCode() throws -> UInt16 {
		return try getAttribute(VI_ATTR_MODEL_CODE, as: UInt16.self)
	}
	
	
	/// Getsthe model name for the device (VI_ATTR_MODEL_NAME)
	///
	/// - Returns: The model name for the device
	/// - Throws: <#throws value description#>
	func getModelName() throws -> String {
		return try getAttribute(VI_ATTR_MODEL_NAME, as: String.self)
	}
	
	
	/// Gets whether the device is IEEE-488.2 compliant (VI_ATTR_4882_COMPLIANT)
	///
	/// - Returns: Whether the device is IEEE-488.2 compliant
	/// - Throws: <#throws value description#>
	func getIs4882Compliant() throws -> Bool {
		return try getAttribute(VI_ATTR_4882_COMPLIANT, as: Bool.self)
	}
}
