//
// Created by Avinash on 2019-05-29.
// Copyright (c) 2019 SwiftVISA. All rights reserved.
//

import Foundation

extension MessageBasedInstrument {
    /// readMultiple() simply calls read with a time delay between each successive call
    ///
    /// - Parameters
    ///     - numberOfReads: the number of reads to be made
    ///     - as: the type to be returned
    ///     - timeDelay: how long to wait between reads, defaults to 25 ms. Specifically, this is the time between the START of each read, not BETWEEN each read. If a read() takes longer than timeDelay(), that read is skipped.
    public func readMultiple<T: VISADecodable>(numberOfReads: Int, as: T, timeDelay: TimeInterval = 0.025) throws -> [T?] {
        #warning("Not tested")
        var readList: [T?] = []

        for _ in 1...numberOfReads {
            let startTime = Date()
            readList.append(try? self.read(as: T.self))
            let endTime = Date()

            let timeElapsed = endTime.timeIntervalSince(startTime)

            // Calculation of the time delay before we call read again
            let currentTimeDelay = timeDelay - timeElapsed

            if (currentTimeDelay < 0) {
                usleep(UInt32(currentTimeDelay * 1000000.0))
            }
        }

        return readList
    }

    /// readMultiple() simply calls read with a time delay between each successive call
    ///
    /// - Parameters
    ///     - numberOfReads: the number of reads to be made
    ///     - as: the type to be returned
    ///     - decoder: the specific decoder to be used.
    ///     - timeDelay: how long to wait between successive reads, defaults to 25 ms
    public func readMultiple<T: VISADecodable, D: VISADecoder>(numberOfReads: Int, as: T, decoder: D, timeDelay: TimeInterval = 0.025) throws -> T where D.DecodingType == T {
        #warning("Not implemented")
        return try(read(as: T.self, decoder: decoder))
    }
}