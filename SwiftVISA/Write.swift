//
//  Write.swift
//  SwiftVISA
//
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

func visaWrite(to session: ViSession, _ string: String) -> ViStatus {
	var returnCount = ViUInt32()
	return viWrite(session, string, ViUInt32(string.count), &returnCount)
}
