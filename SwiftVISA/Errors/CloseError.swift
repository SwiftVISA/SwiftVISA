//
//  CloseError.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/28/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

public enum CloseError: Error {
	case invalidSession
	case closingFailed
}

extension CloseError {
	init?(_ status: ViStatus) {
		switch status {
		case VI_ERROR_INV_OBJECT:
			self = .invalidSession
		case VI_ERROR_CLOSING_FAILED:
			self = .closingFailed
		default:
			return nil
		}
	}
}
