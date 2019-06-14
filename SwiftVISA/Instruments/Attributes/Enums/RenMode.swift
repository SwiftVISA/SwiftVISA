//
//  RenState.swift
//  SwiftVISA
//  An enumerator representing GPIB REN (Remote Enable) interface line states
//  Maps constants relating to VI_ATTR_GPIB_REN_STATE
//  Created by visaman on 6/10/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//
import CVISA

public enum RenMode {
	
	var renCode: Int32 {
		switch self {
		case .deassert:
			return VI_GPIB_REN_DEASSERT
		case .assert:
			return VI_GPIB_REN_ASSERT
		case .deassertGTL:
			return VI_GPIB_REN_DEASSERT_GTL
		case .assertAddress:
			return VI_GPIB_REN_ASSERT_ADDRESS
		case .assertLLO:
			return VI_GPIB_REN_ASSERT_LLO
		case .assertAddressLLO:
			return VI_GPIB_REN_ASSERT_ADDRESS_LLO
		case .addressGTL:
			return VI_GPIB_REN_ADDRESS_GTL
			
		}
	}
	case deassert
	case assert
	case deassertGTL
	case assertAddress
	case assertLLO
	case assertAddressLLO
	case addressGTL
}
