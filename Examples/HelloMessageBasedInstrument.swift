//
// Created by Luke H on 2019-06-10.
// Copyright (c) 2019 SwiftVISA. All rights reserved.
//

import SwiftVISA

let im = InstrumentManager.default
let multimeter = try? InstrumentManager.makeInstrument("USB0::0x0957::0x1A07::MY53205040::0::INSTR") as? MessageBasedInstrument
print(try? multimeter?.query("MEASURE:SCALAR:VOLTAGE:DC?", as: Double.self))

