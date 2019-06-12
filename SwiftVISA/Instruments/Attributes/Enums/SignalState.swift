//
//  InterfaceType.swift
//	Enum that handles mapping VI_INTF_.* C constants to an enumerator
//  SwiftVISA
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
