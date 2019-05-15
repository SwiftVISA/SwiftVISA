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

public func readVoltage(from session: ViSession) -> Double? {
	visaWrite(to: session, "MEASURE:VOLTAGE:DC?")
	let result = visaRead(to: session, bufferSize: 200)
	switch result {
	case .success(let string):
		guard let double = Double(string) else { return nil }
		return double
	case .error(_):
		return nil
	}
}
