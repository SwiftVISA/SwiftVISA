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
    /// - Throws: ???
    func setAttribute(_ attributeId: ViAttr, value: Int) throws {
        #warning("Not tested")
        let status = viSetAttribute(session.viSession, attributeId, ViAttrState(value))
        guard status >= VI_SUCCESS else { throw VISAError(status)}
    }
	
	/// Gets the given NI-VISA attribute on the instrument
    /// Returns the raw data retreived from the device
	///
	/// - Throws: ???
	private func getAttribute(_ attributeId: ViAttr) throws -> Data {
		#warning("Not tested")
		let buffer = ViPBuf.allocate(capacity: 2048)
		let status = viGetAttribute(session.viSession, attributeId, buffer)
		
		guard status >= VI_SUCCESS else { throw VISAError(status) }
		// convert the data to a readable string format
		let pointer = UnsafeRawPointer(buffer)
		let bytes = MemoryLayout<UInt8>.stride * 2048
		let data = Data(bytes: pointer, count: bytes)
        return data
        /*
        print()
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
        */
	}
    
    /// Gets the given NI-VISA attribute on the instrument as a type
    /// Also has the additional feature of providing a decoder for the attribute
    ///
    /// - Throws: VisaError.couldNotDecode
    /*
    func getAttribute<T, D: VISADecoder>(_ attributeId: ViAttr, as type: T.Type, decoder: D) throws -> T where D.DecodingType == T {
        let visaData = try getAttribute(attributeId)
        return T()
        // return decoder.decode(visaData)
    }
 */
    
    /// Gets the given NI-VISA attribute on the instrument as a type
    ///
    /// - Throws: VisaError.couldNotDecode
    func getAttribute<T: VISADecodable>(_ attributeId: ViAttr, as type: T.Type) throws -> T {
        let visaData = try getAttribute(attributeId)
        return visaData.withUnsafeBytes {
            $0.load(as: T.self)
        }
    }
}
