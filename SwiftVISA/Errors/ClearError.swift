//
//  ClearError.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/28/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

public enum ClearError: Error {
	case invalidSession
	case unsupportedOperation
	case resourceLocked
	case timeout
	case rawWriteProtocolViolation
	case rawReadProtocolViolation
	case busError
	case notControllerInCharge
	case noListeners
	case invalidSetup
	case connectionLost
}

extension ClearError {
	init?(_ status: ViStatus) {
		switch status {
		case VI_ERROR_INV_OBJECT:
			self = .invalidSession
		case VI_ERROR_NSUP_OPER:
			self = .unsupportedOperation
		case VI_ERROR_RSRC_LOCKED:
			self = .resourceLocked
		case VI_ERROR_TMO:
			self = .timeout
		case VI_ERROR_RAW_WR_PROT_VIOL:
			self = .rawWriteProtocolViolation
		case VI_ERROR_RAW_RD_PROT_VIOL:
			self = .rawReadProtocolViolation
		case VI_ERROR_BERR:
			self = .busError
		case VI_ERROR_NCIC:
			self = .notControllerInCharge
		case VI_ERROR_NLISTENERS:
			self = .noListeners
		case VI_ERROR_INV_SETUP:
			self = .invalidSetup
		case VI_ERROR_CONN_LOST:
			self = .connectionLost
		default:
			return nil
		}
	}
}
