//
//  InterfaceType.swift
//	Enum that handles mapping VI_INTF_.* C constants to an enumerator
//  SwiftVISA
//
//  Created by visaman on 6/10/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.

import CVISA

public enum InterfaceType: UInt16 {
	case gpib
	case vxi
	case gpib_vxi
	case serial
	case pxi
	case tcpip
	case usb
	case unknown
}

extension InterfaceType {
	init(_ interface: UInt16) {
		switch interface {
		case UInt16(VI_INTF_PXI):
			self = .pxi
		case UInt16(VI_INTF_GPIB):
			self = .gpib
		case UInt16(VI_INTF_GPIB_VXI):
			self = .gpib_vxi
		case UInt16(VI_INTF_USB):
			self = .usb
		case UInt16(VI_INTF_TCPIP):
			self = .tcpip
		case UInt16(VI_INTF_VXI):
			self = .vxi
		case UInt16(VI_INTF_ASRL):
			self = .serial
		default:
			self = .unknown
		}
	}
}
