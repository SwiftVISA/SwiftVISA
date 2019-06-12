//
//  AtnMode.swift
//  SwiftVISA
//
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
