//
//  Session.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/28/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

public class Session {
	var viSession: ViSession
	
	init(viSession: ViSession) {
		self.viSession = viSession
	}
}
