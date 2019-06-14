//
//  SerialAttributes.swift
//  SwiftVISA
//
//  Created by visaman on 6/11/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

extension SerialInstrument {
	
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
		try setAttribute(VI_ATTR_IO_PROT, value: ioProtocol.protoCode)
	}
	
	
	/// Sets the baud rate for the connection (VI_ATTR_ASRL_BAUD)
	///
	/// - Parameter rate: An unsigned 32-bit integer; usually requires a common rate (i.e 300, 1200, 2400, 9000)
	/// - Throws: <#throws value description#>
	func setBaudRate(rate: Int) throws {
		try setAttribute(VI_ATTR_ASRL_BAUD, value: rate)
	}
	
	
	/// Gets the baud rate for the connection (VI_ATTR_ASRL_BAUD)
	///
	/// - Returns: The baud rate for the connection
	/// - Throws: <#throws value description#>
	func getBaudRate() throws -> Int {
		return try Int(getAttribute(VI_ATTR_ASRL_BAUD, as: UInt32.self))
	}
	
	
	/// Gets the break state as defined by the attribute VI_ATTR_ASRL_BREAK_STATE
	///
	/// - Returns: The break state of the connection
	/// - Throws: <#throws value description#>
	func getBreakState() throws -> SignalState {
		return try SignalState(getAttribute(VI_ATTR_ASRL_BREAK_STATE, as: Int16.self))
	}
	
	/// Sets the break state as defined by the attribute VI_ATTR_ASRL_BREAK_STATE
	///
	/// - Parameter state: The break state to set for the connection
	/// - Throws: <#throws value description#>
	func setBreakState(state: SignalState) throws {
		try setAttribute(VI_ATTR_ASRL_BREAK_STATE, value: state.signalCode)
	}
	
	
	/// Gets the break signal duration (VI_ATTR_ASRL_BREAK_LEN)
	///
	/// - Returns: <#return value description#>
	/// - Throws: <#throws value description#>
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
	
	
	/// Gets the state of the Clear To Send (CTS) signal (VI_ATTR_ASRL_CTS_STATE)
	///
	/// - Returns: The state of the signal (see SignalState)
	/// - Throws: <#throws value description#>
	func getCtsSignalState() throws -> SignalState {
		return try SignalState(getAttribute(VI_ATTR_ASRL_CTS_STATE, as: Int16.self))
	}
	
	
	/// Sets the state of the Clear To Send (CTS) signal (VI_ATTR_ASRL_CTS_STATE)
	///
	/// - Parameter state: The state of the signal (see SignalState)
	/// - Throws: <#throws value description#>
	func setCtsSignalState(state: SignalState) throws {
		try setAttribute(VI_ATTR_ASRL_CTS_STATE, value: state.signalCode)
	}
	
	
	/// Gets the Data Carrier Detect input signal state (VI_ATTR_ASRL_DCD_STATE)
	///
	/// - Returns: The data carrier detect input signal state
	/// - Throws: <#throws value description#>
	func getDCDSignalState() throws -> SignalState {
		return try SignalState(getAttribute(VI_ATTR_ASRL_DCD_STATE, as: Int16.self))
	}
	
	
	/// Sets the Data Carrier Detect input signal state (VI_ATTR_ASRL_DCD_STATE)
	///
	/// - Parameter state: The signal state to set the signal
	/// - Throws: <#throws value description#>
	func setDCDSignalState(state: SignalState) throws {
		try setAttribute(VI_ATTR_ASRL_DCD_STATE, value: state.signalCode)
	}
	
	
	/// Gets the bits per frame located in the lower order bits of every byte stored in memory (VI_ATTR_ASRL_DATA_BITS)
	///
	/// - Returns: The bits per frame ranging between 5 and 8
	/// - Throws: <#throws value description#>
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
	
	
	/// Gets whether NUL characters are discarded by VISA (VI_ATTR_ASRL_DISCARD_NULL)
	///
	/// - Returns: Whether NUL characters are discarded
	/// - Throws: <#throws value description#>
	func getDiscardNullCharacters() throws -> Bool {
		return try getAttribute(VI_ATTR_ASRL_DISCARD_NULL, as: Bool.self)
	}
	
	
	/// Sets whether NUL characters should be discarded or not (VI_ATTR_ASRL_DISCARD_NULL)
	///
	/// - Parameter discard: Whether or not to discard NUL characters
	/// - Throws: <#throws value description#>
	func setDiscardNullCharacters(discard: Bool) throws {
		if discard {
			try setAttribute(VI_ATTR_ASRL_DISCARD_NULL, value: 1)
		} else {
			try setAttribute(VI_ATTR_ASRL_DISCARD_NULL, value: 0)
		}
	}
	
	
	/// Gets the current state of the Data Set Ready signal (VI_ATTR_ASRL_DSR_STATE)
	///
	/// - Returns: The signal state of the DSR signal
	/// - Throws: <#throws value description#>
	func getDSRSignalState() throws -> SignalState {
		return try SignalState(getAttribute(VI_ATTR_ASRL_DSR_STATE, as: Int16.self))
	}
	
	
	/// Sets the current state of the data set ready signal (VI_ATTR_ASRL_DSR_STATE)
	///
	/// - Parameter state: The signal state to set the DSR signal to
	/// - Throws: <#throws value description#>
	func setDSRSignalState(state: SignalState) throws {
		try setAttribute(VI_ATTR_ASRL_DSR_STATE, value: state.signalCode)
	}
	
	
	/// Gets the Data Terminal Ready input signal state (VI_ATTR_ASRL_DTR_STATE)
	///
	/// - Returns: The signal state of the Data Terminal Ready input signal
	/// - Throws: <#throws value description#>
	func getDTRSignalState() throws -> SignalState {
		return try SignalState(getAttribute(VI_ATTR_ASRL_DTR_STATE, as: Int16.self))
	}
	
	/// Sets the Data Terminal Ready input signal state (VI_ATTR_ASRL_DTR_STATE)
	///
	/// - Parameter state: The signal state to set the Data Terminal Ready input signal
	/// - Throws: <#throws value description#>
	func setDTRSignalState(state: SignalState) throws {
		try setAttribute(VI_ATTR_ASRL_DTR_STATE, value: state.signalCode)
	}

}
