//
//  ReadError.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/15/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

/// An error that can be thrown during a read operation.
///
/// - invalidSession: The given session is invalid.
/// - unsupportedOperation: The given vi does not support this operation.
/// - resourceLocked: The resource has been locked or this kind of access.
/// - timeout: The operation could not be completed in the specified time.
/// - rawWriteViolation: Violation of raw write protocol occurred during transfer.
/// - rawReadViolation: Violation of raw read protocol occurred during transfer.
/// - outputError: Device reported an output protocol error during transfer.
/// - busError: A bus error occurred during transfer.
/// - invalidSetup: The read operation could not be started becuase the settup is invalid due to attributes being set to an inconsistant state.
/// - notControllerInCharge: The interface associated with the given vi is not currently the controller in charge.
/// - noListeners: No listeners condition is detected.
/// - parityError: A parity error occured during transfer.
/// - framingError: A framing error occured during transfer.
/// - overrunError: An overrun error occured during transfer. A character was not read from the hardware before the next character arrived.
/// - ioError: An unknown I/O error occurred during transfer.
/// - connectionLost: The I/O connection for the given session was lost.
/// - returnCountExceededBufferLength: The device sent more data than the buffer could hold.
/// - couldNotDecode: The data from the device could not be decoded into a `String`.
/// - wrongType: The data was not convertable to the expected type.
public enum ReadError: Error {
	case invalidSession
	case unsupportedOperation
	case resourceLocked
	case timeout
	case rawWriteViolation
	case rawReadViolation
	case outputError
	case busError
	case invalidSetup
	case notControllerInCharge
	case noListeners
	case parityError
	case framingError
	case overrunError
	case ioError
	case connectionLost
	case returnCountExceededBufferLength
	case couldNotDecode
	case wrongType
}

extension ReadError {
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
		case VI_ERROR_OUTP_PROT_VIOL:
			self = .outputError
		case VI_ERROR_BERR:
			self = .busError
		case VI_ERROR_INV_SETUP:
			self = .invalidSetup
		case VI_ERROR_NCIC:
			self = .notControllerInCharge
		case VI_ERROR_NLISTENERS:
			self = .noListeners
		case VI_ERROR_ASRL_PARITY:
			self = .parityError
		case VI_ERROR_ASRL_FRAMING:
			self = .framingError
		case VI_ERROR_ASRL_OVERRUN:
			self = .overrunError
		case VI_ERROR_IO:
			self = .ioError
		case VI_ERROR_CONN_LOST:
			self = .connectionLost
		default:
			return nil
		}
	}
}
