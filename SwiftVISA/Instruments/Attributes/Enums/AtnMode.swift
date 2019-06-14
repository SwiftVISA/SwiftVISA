//
//  AtnMode.swift
//  SwiftVISA
//  Enumerator representing GPIB ATIN (Attention) interface line states
//  maps constants relating to VI_ATTR_GPIB_ATN_STATE
//  Created by visaman on 6/10/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//
import CVISA

public enum AtnMode {
	var atnCode: Int32 {
		switch self {
		case .deassert:
			return VI_GPIB_ATN_DEASSERT
		case .assert:
			return VI_GPIB_ATN_ASSERT
		case .deassertHandshake:
			return VI_GPIB_ATN_DEASSERT_HANDSHAKE
		case .assertImmediate:
			return VI_GPIB_ATN_ASSERT_IMMEDIATE
		}
	}
	case deassert
	case assert
	case deassertHandshake
	case assertImmediate
}
