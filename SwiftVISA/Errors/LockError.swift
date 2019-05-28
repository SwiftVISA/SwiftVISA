//
//  LockError.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/28/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

public enum LockError: Error {
	case invalidSession
	case resourceLocked
	case invalidLockType
	case invalidAccessKey
	case invalidRequestKey
	case timeout
}

extension LockError {
	init?(_ status: ViStatus) {
		switch status {
		case VI_ERROR_INV_OBJECT:
			self = .invalidSession
		case VI_ERROR_RSRC_LOCKED:
			self = .resourceLocked
		case VI_ERROR_INV_LOCK_TYPE:
			self = .invalidLockType
		case VI_ERROR_INV_ACCESS_KEY:
			self = .invalidAccessKey
		case VI_ERROR_TMO:
			self = .timeout
		default:
			return nil
		}
	}
}
