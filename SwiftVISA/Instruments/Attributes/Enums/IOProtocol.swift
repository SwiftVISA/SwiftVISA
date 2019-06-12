//
//  InterfaceType.swift
//	Enum that handles mapping VI_INTF_.* C constants to an enumerator
//  SwiftVISA
//
//  Created by visaman on 6/10/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.

import CVISA

public enum IOProtocol: UInt16 {
	
	var protoCode: Int {
		switch self {
		case .normal:
			return Int(VI_PROT_NORMAL)
		case .fdc:
			return Int(VI_PROT_FDC)
		case .hs488:
			return Int(VI_PROT_HS488)
		case .ieee4882:
			return Int(VI_PROT_4882_STRS)
		case .usbtmc_vendor:
			return Int(VI_PROT_USBTMC_VENDOR)
		case .unknown:
			return -1
		}
	}
	
	case normal
	case fdc
	case hs488
	case ieee4882
	case usbtmc_vendor
	case unknown
}

extension IOProtocol {
	
	init(_ interface: UInt16) {
		switch interface {
		case UInt16(VI_PROT_FDC):
			self = .fdc
		case UInt16(VI_PROT_HS488):
			self = .hs488
		case UInt16(VI_PROT_NORMAL):
			self = .normal
		case UInt16(VI_PROT_4882_STRS):
			self = .ieee4882
		case UInt16(VI_PROT_USBTMC_VENDOR):
			self = .usbtmc_vendor
		default:
			self = .unknown
		}
	}
}
