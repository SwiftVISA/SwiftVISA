//
//  Voltage.swift
//  SwiftVISATests
//
//  Created by Avinash on 5/15/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

public func setVoltage(to session: ViSession, voltage: Double) -> ViStatus{
	return visaWrite(to: session, "SOURCE1:FUNCTION SQU:VOLTAGE \(voltage)")
}
