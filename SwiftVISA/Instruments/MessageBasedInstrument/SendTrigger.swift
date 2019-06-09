//
// Created by Avinash on 2019-06-03.
// Copyright (c) 2019 SwiftVISA. All rights reserved.
//

import CVISA

extension MessageBasedInstrument {
    /// Sends a software trigger to the device.
    ///     According to NI-VISA, you can configure the hardware to wait for a trigger to do anything.
    ///     This sends that trigger
    public func assertTrigger() throws {
        #warning("Not tested")
        try assertTrigger(VI_TRIG_PROT_DEFAULT)
    }
}