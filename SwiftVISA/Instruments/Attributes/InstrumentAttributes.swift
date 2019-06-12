//
//  Instrument.swift
//  SwiftVISA
//
//  Created by visaman on 6/11/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//
import CVISA

public extension Instrument {
	func getManufacturerName() throws -> String {
		return try getAttribute(VI_ATTR_MANF_NAME, as: String.self)
	}
	
	func getManufacturerId() throws -> UInt16 {
		return try getAttribute(VI_ATTR_MANF_ID, as: UInt16.self)
	}
	
	func getInstrumentName() throws -> String {
		return try getAttribute(VI_ATTR_INTF_INST_NAME, as: String.self)
	}
	
	func getInterfaceNumber() throws -> UInt16 {
		return try getAttribute(VI_ATTR_INTF_NUM, as: UInt16.self)
	}
	
	func getInterfaceType() throws -> InterfaceType {
		return InterfaceType(try getAttribute(VI_ATTR_INTF_TYPE, as: UInt16.self))
	}
	
	func getMaxQueueLength() throws -> UInt32{
		return try getAttribute(VI_ATTR_MAX_QUEUE_LENGTH, as: UInt32.self)
	}
	
	func setMaxQueueLength(length: UInt32) throws {
		try setAttribute(VI_ATTR_MAX_QUEUE_LENGTH, value: Int(length))
	}
	
	func getResourceClass() throws -> String {
		return try getAttribute(VI_ATTR_RSRC_CLASS, as: String.self)
	}
	
	func getResourceImplementationVersion() throws -> UInt32 {
		return try getAttribute(VI_ATTR_RSRC_IMPL_VERSION, as: UInt32.self)
	}
	
	func getTimeout() throws -> Int {
		return try Int(getAttribute(VI_ATTR_TMO_VALUE, as: UInt32.self))
	}
	
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
