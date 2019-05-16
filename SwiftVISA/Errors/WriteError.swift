//
//  WriteError.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/16/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

/// An error that can be thrown during a write operation.
///
/// - invalidSession: The given session is invalid.
/// - unsupportedOperation: The given vi does not support this operation.
/// - resourceLocked: The resource has been locked for this kind of access.
/// - timeout: The operation could not be completed in the specified time.
/// - rawWriteViolation: Violation of raw write protocol occurred during transfer.
/// - rawReadViolation: Violation of raw read protocol occurred during transfer.
/// - inputError: Device reported an input protocol error during transfer.
/// - busError: A bus error occurred during transfer.
/// - invalidSetup: The write operation could not be started becuase the settup is invalid due to attributes being set to an inconsistant state.
/// - notControllerInCharge: The interface associated with the given vi is not currently the controller in charge.
/// - noListeners: No listeners condition is detected.
/// - ioError: An unknown I/O error occurred during transfer.
/// - connectionLost: The I/O connection for the given session was lost.
public enum WriteError: Error {
	case invalidSession
	case unsupportedOperation
	case resourceLocked
	case timeout
	case rawWriteViolation
	case rawReadViolation
	case inputError
	case busError
	case invalidSetup
	case notControllerInCharge
	case noListeners
	case ioError
	case connectionLost
}

extension WriteError {
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
			self = .rawWriteViolation
		case VI_ERROR_RAW_RD_PROT_VIOL:
			self = .rawReadViolation
		case VI_ERROR_INP_PROT_VIOL:
			self = .inputError
		case VI_ERROR_BERR:
			self = .busError
		case VI_ERROR_INV_SETUP:
			self = .invalidSetup
		case VI_ERROR_NCIC:
			self = .notControllerInCharge
		case VI_ERROR_NLISTENERS:
			self = .noListeners
		case VI_ERROR_IO:
			self = .ioError
		case VI_ERROR_CONN_LOST:
			self = .connectionLost
		default:
			return nil
		}
	}
}
