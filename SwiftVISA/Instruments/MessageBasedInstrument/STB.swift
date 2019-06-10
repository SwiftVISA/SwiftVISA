//
// Created by Avinash on 2019-06-09.
// Copyright (c) 2019 SwiftVISA. All rights reserved.
//

import CVISA

extension MessageBasedInstrument {
    public func readSTB() throws -> String {
        var result = ViPUInt16() // AKA: UnsafeMutablePointer<UInt16>
        let status = viReadSTB(session.viSession, result)

        guard status >= VI_SUCCESS else {
            throw VISAError(status)
        }

        let pointer = UnsafeRawPointer(result)
        let bytes = MemoryLayout<UInt8>.stride * 16 // TODO: Verify 16 is the size of a UInt16?
        let data = Data(bytes: pointer, count: bytes)
        guard let string = String(data: data, encoding: .ascii) else {
            throw VISAError.couldNotDecode
        }

        return string
    }
}