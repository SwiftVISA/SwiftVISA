//
//  InstrumentProtocol.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/30/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

/// This is an internal helper protocol for adding functionality to instruments.
protocol InstrumentProtocol: Instrument {
	init(session: Session, identifier: String)
}
