//
//  Instrument.swift
//  SwiftVISA
//
//  Created by Avinash on 5/15/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

/// An object that represents an instrument that can be communicated with.
public protocol Instrument {
	var session: Session { get }
	var uniqueIdentifier: String { get }
	var beforeClose: () -> Void { get set }
	var lockState: LockState { get set }
}

