//
//  InterfaceType.swift
//  SwiftVISA
//	Enum that represents signal state for any signal related attributes
//  handles mapping VI_STATE_.* C constants
//
//  Created by visaman on 6/10/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.

import CVISA

public enum SignalState: Int {
	
	var signalCode: Int {
		switch self {
		case .asserted:
			return Int(VI_STATE_ASSERTED)
		case .unasserted:
			return Int(VI_STATE_UNASSERTED)
		case .unknown:
			return Int(VI_STATE_UNKNOWN)
		}
	}
	
	case asserted
	case unasserted
	case unknown
}

extension SignalState {
	
	init(_ interface: Int16) {
		switch Int32(interface) {
		case VI_STATE_ASSERTED:
			self = .asserted
		case VI_STATE_UNASSERTED:
			self = .unasserted
		case VI_STATE_UNKNOWN:
			self = .unknown
		default:
			self = .unknown
		}
	}
}
