//
//  Instrument.swift
//  SwiftVISA
//
//  Created by visaman on 6/11/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//
import CVISA

public extension Instrument {
	
	/// Gets the name of the manufacturer of the instrument (VI_ATTR_MANF_NAME)
	///
	/// - Returns: The name of the manufacturer
	/// - Throws: <#throws value description#>
	func getManufacturerName() throws -> String {
		return try getAttribute(VI_ATTR_MANF_NAME, as: String.self)
	}
	
	/// The manufacturer identification number of the device. (VI_ATTR_MANF_ID)
	/// For VXI resources: the VXI Manufacturer ID.
	/// For PXI INSTR resources: if the subsystem PCI Vendor ID is nonzero, this refers to the subsystem Vendor ID. Otherwise, this refers to the Vendor ID.
	/// For USB resources: the Vendor ID (VID).
	///
	/// - Returns: The manufacturer identification number
	/// - Throws: <#throws value description#>
	func getManufacturerId() throws -> UInt16 {
		return try getAttribute(VI_ATTR_MANF_ID, as: UInt16.self)
	}
	
	
	/// Gets the name of the instrument (VI_ATTR_INTF_INST_NAME)
	///
	/// - Returns: The name of the instrument
	/// - Throws: <#throws value description#>
	func getInstrumentName() throws -> String {
		return try getAttribute(VI_ATTR_INTF_INST_NAME, as: String.self)
	}
	
	
	/// Specifies the board number for the interface (VI_ATTR_INTF_NUM)
	///
	/// - Returns: <#return value description#>
	/// - Throws: <#throws value description#>
	func getInterfaceNumber() throws -> UInt16 {
		return try getAttribute(VI_ATTR_INTF_NUM, as: UInt16.self)
	}
	
	
	/// Gets the interface type of the instrument (VI_ATTR_INTF_TYPE)
	///
	/// - Returns: The interface type of the instrument
	/// - Throws: <#throws value description#>
	func getInterfaceType() throws -> InterfaceType {
		return InterfaceType(try getAttribute(VI_ATTR_INTF_TYPE, as: UInt16.self))
	}
	
	
	/// Gets the maximum number of events that can be queued at a time (VI_ATTR_MAX_QUEUE_LENGTH)
	///
	/// - Returns: The current maximum size of the queue for events
	/// - Throws: <#throws value description#>
	func getMaxQueueLength() throws -> UInt32{
		return try getAttribute(VI_ATTR_MAX_QUEUE_LENGTH, as: UInt32.self)
	}
	
	/// Sets the maximum number of events that can be queued at a time (VI_ATTR_MAX_QUEUE_LENGTH)
	///
	/// - Parameter length: The maximum amount of events that can be queued at once
	/// - Throws: <#throws value description#>
	func setMaxQueueLength(length: UInt32) throws {
		try setAttribute(VI_ATTR_MAX_QUEUE_LENGTH, value: Int(length))
	}
	
	
	/// Gets the resource class defined by the canoical resource name (VI_ATTR_RSRC_CLASS)
	///
	/// - Returns: The resource class of the instrument
	/// - Throws: <#throws value description#>
	func getResourceClass() throws -> String {
		return try getAttribute(VI_ATTR_RSRC_CLASS, as: String.self)
	}
	
	
	/// Gets an integer that uniquely identifies the resource implementation of an instriment. This is defined by the individual manufacturer and increments with each new revision. The format of the value has the upper 12 bits as the major number of the version, the next lower 12 bits as the minor number of the version, and the lowest 8 bits as the sub-minor number of the version. (VI_ATTR_RSRC_IMPL_VERSION)
	///
	/// - Returns: The implementation version of the device
	/// - Throws: <#throws value description#>
	func getResourceImplementationVersion() throws -> UInt32 {
		return try getAttribute(VI_ATTR_RSRC_IMPL_VERSION, as: UInt32.self)
	}
	
	
	/// Gets tje to,epit fpr reqiests to instruments in milliseconds (VI_ATTR_TMO_VALUE)
	///
	/// - Returns: The timeout for instrument requests
	/// - Throws: <#throws value description#>
	func getTimeout() throws -> Int {
		return try Int(getAttribute(VI_ATTR_TMO_VALUE, as: UInt32.self))
	}
	
	
	/// Sets the timeout for requests to instruments in milliseconds (VI_ATTR_TMO_VALUE); default 2000
	///
	/// - Parameter value: The value to
	/// - Throws: <#throws value description#>
	func setTimeout(value: Int) throws {
		try setAttribute(VI_ATTR_TMO_VALUE, value: value)
	}
	
	/* TODO figure out lock state since we already have a lock enum
	func getResourceLockState() throws -> LockState {
	switch try getAttribute(VI_ATTR_RSRC_LOCK_STATE, as: UInt32.self) {
	case UInt32(VI_NO_LOCK):
	return .unlocked
	case UInt32(VI_SHARED_LOCK):
	return .shared
	case UInt32(VI_EXCLUSIVE_LOCK):
	return .exclusive
	}
	}
	*/
}
