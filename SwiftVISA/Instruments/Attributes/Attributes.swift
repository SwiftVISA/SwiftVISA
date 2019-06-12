//
//  Attributes.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 6/3/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

extension Instrument {
	
    /// sets the given NI-VISA attribute on the instrument using an int argument
    ///
    /// - Parameters:
    ///   - attributeId: The VISA Attribute ID to set
    ///   - value: The value of the 
    /// - Throws: <#throws value description#>
    func setAttribute(_ attributeId: UInt, value: Int) throws {
        #warning("Not unit tested")
        let status = viSetAttribute(session.viSession, ViAttr(attributeId), ViAttrState(value))
        guard status >= VI_SUCCESS else { throw VISAError(status)}
    }
	
	/// Gets the given NI-VISA attribute on the instrument
	/// Returns the raw data retreived from the device
	///
	/// - Parameter attributeId: The VISA Attribute ID to set
	/// - Returns: The raw data received from the device
	/// - Throws: <#throws value description#>
	private func getAttribute(_ attributeId: UInt) throws -> Data {
		#warning("Not tested")
		let buffer = ViPBuf.allocate(capacity: 2048)
		let status = viGetAttribute(session.viSession, ViAttr(attributeId), buffer)
		
		guard status >= VI_SUCCESS else { throw VISAError(status) }
		// convert the data to a readable string format
		let pointer = UnsafeRawPointer(buffer)
		let bytes = MemoryLayout<UInt8>.stride * 2048
		let data = Data(bytes: pointer, count: bytes)
        return data
	}

    /// Gets the given NI-VISA attribute on the instrument as a type
    ///
    /// - Parameters:
    ///   - attributeId: The VISA Attribute ID to get
    ///   - type: The type to cast the data to
    /// - Returns: The data returned from the device, cast to the type
    /// - Throws: <#throws value description#>
    func getAttribute<T>(_ attributeId: UInt, as type: T.Type) throws -> T {
        let visaData = try getAttribute(attributeId)
		if type == String.self {
			let string = String(bytes: visaData, encoding: .ascii)!
			let startIndex = string.startIndex
			let endIndex = string.firstIndex(of: "\0") ?? string.endIndex
			return String(string[startIndex..<endIndex]) as! T
		}
        return visaData.withUnsafeBytes {
            $0.load(as: T.self)
        }
    }
}
