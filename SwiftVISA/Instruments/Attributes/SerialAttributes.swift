//
//  SerialAttributes.swift
//  SwiftVISA
//
//  Created by visaman on 6/11/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

public extension SerialInstrument {
	func getIOProtocol() throws -> IOProtocol {
		return try IOProtocol(getAttribute(VI_ATTR_IO_PROT, as: UInt16.self))
	}
	
	func setIOProtocol(ioProtocol: IOProtocol) throws {
		try setAttribute(VI_ATTR_IO_PROT, value: ioProtocol.protoCode)
	}
	
	func setBaudRate(rate: Int) throws {
		try setAttribute(VI_ATTR_ASRL_BAUD, value: rate)
	}
	
	func getBaudRate() throws -> Int {
		return try Int(getAttribute(VI_ATTR_ASRL_BAUD, as: UInt32.self))
	}
	
	func getBreakState() throws -> SignalState {
		return try SignalState(getAttribute(VI_ATTR_ASRL_BREAK_STATE, as: Int16.self))
	}
	
	func setBreakState(state: SignalState) throws {
		try setAttribute(VI_ATTR_ASRL_BREAK_STATE, value: state.signalCode)
	}
	
	func getBreakSignalDuration() throws -> Int {
		return try Int(getAttribute(VI_ATTR_ASRL_BREAK_LEN, as: Int16.self))
	}
	
	/// Sets the break signal duration of the device (VI_ATTR_ASRL_BREAK_LEN)
	/// MUST be between 1 and 500
	///
	/// - Returns: <#return value description#>
	/// - Throws: <#throws value description#>
	func setBreakSignalDuration(duration: Int) throws {
		try setAttribute(VI_ATTR_ASRL_BREAK_LEN, value: duration)
	}
	
	
	/// Gets the state of the Clear To Send (CTS) signal
	///
	/// - Returns: The state of the signal (see SignalState)
	/// - Throws: <#throws value description#>
	func getCtsSignalState() throws -> SignalState {
		return try SignalState(getAttribute(VI_ATTR_ASRL_CTS_STATE, as: Int16.self))
	}
	
	
	/// Sets the state of the Clear To Send (CTS) signal
	///
	/// - Parameter state: The state of the signal (see SignalState)
	/// - Throws: <#throws value description#>
	func setCtsSignalState(state: SignalState) throws {
		try setAttribute(VI_ATTR_ASRL_CTS_STATE, value: state.signalCode)
	}
	
	func getDCDSignalState() throws -> SignalState {
		return try SignalState(getAttribute(VI_ATTR_ASRL_DCD_STATE, as: Int16.self))
	}
	
	func setDCDSignalState(state: SignalState) throws {
		try setAttribute(VI_ATTR_ASRL_DCD_STATE, value: state.signalCode)
	}
	
	func getBitsPerFrame() throws -> Int {
		return try Int(getAttribute(VI_ATTR_ASRL_DATA_BITS, as: UInt16.self))
	}
	
	
	/// Sets the number of data bits contained in each frame (from 5 to 8). The data bits for each frame are located in the low-order bits of every byte stored in memory.
	///
	/// - Parameter numberOfBits: An integer between 5 and 8
	/// - Throws: <#throws value description#>
	func setBitsPerFrame(numberOfBits: Int) throws {
		try setAttribute(VI_ATTR_ASRL_DATA_BITS, value: numberOfBits)
	}
	
	func getDiscardNullCharacters() throws -> Bool {
		return try getAttribute(VI_ATTR_ASRL_DISCARD_NULL, as: Bool.self)
	}
	
	func setDiscardNullCharacters(discard: Bool) throws {
		if discard {
			try setAttribute(VI_ATTR_ASRL_DISCARD_NULL, value: 1)
		} else {
			try setAttribute(VI_ATTR_ASRL_DISCARD_NULL, value: 0)
		}
	}
	func getDSRSignalState() throws -> SignalState {
		return try SignalState(getAttribute(VI_ATTR_ASRL_DSR_STATE, as: Int16.self))
	}
	
	func setDSRSignalState(state: SignalState) throws {
		try setAttribute(VI_ATTR_ASRL_DSR_STATE, value: state.signalCode)
	}
	
	func getDTRSignalState() throws -> SignalState {
		return try SignalState(getAttribute(VI_ATTR_ASRL_DTR_STATE, as: Int16.self))
	}
	
	func setDTRSignalState(state: SignalState) throws {
		try setAttribute(VI_ATTR_ASRL_DTR_STATE, value: state.signalCode)
	}

}
