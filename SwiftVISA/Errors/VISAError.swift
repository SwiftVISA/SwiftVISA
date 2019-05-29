//
//  VISAError.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/28/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

/// An error that can be thrown by the SwiftVISA framework.
///
/// - systemError: Unknown system error (miscellaneous error).
/// - invalidSession: The given session or object reference is invalid.
/// - resourceLocked: Specified type of lock cannot be obtained or specified operation cannot be performed, because the resource is locked.
/// - invalidExpressionForSearch: Invalid expression specified for search.
/// - resourceNotFound: Insufficient location information or the device or resource is not present in the system.
/// - invalidResourceName: Invalid resource reference specified. Parsing error.
/// - invalidAccessMode: Invalid access mode.
/// - timeout: Timeout expired before operation completed.
/// - failedToClose: Unable to deallocate the previously allocated data structures corresponding to this session or object reference.
/// - invalidDegree: Specified degree is invalid.
/// - invalidJobIdentifier: Specified job identifier is invalid.
/// - unsupportedAttribute: The specified attribute is not defined or supported by the referenced session, event, or find list.
/// - unsupportedAttributeState: The specified state of the attribute is not valid, or is not supported as defined by the session, event, or find list.
/// - readOnlyAttribute: The specified attribute is Read Only.
/// - invalidLockType: The specified type of lock is not supported by this resource.
/// - invalidAccessKey: The access key to the resource associated with this session is invalid.
/// - invalidEvent: Specified event type is not supported by the resource.
/// - invalidMechanism: Invalid mechanism specified.
/// - handlerNotInstalled: A handler is not currently installed for the specified event.
/// - invalidHandlerReference: The given handler reference is invalid.
/// - invalidContext: Specified event context is invalid.
/// - queueOverflow: The event queue for the specified type has overflowed (usually due to previous events not having been closed).
/// - eventNotEnabled: The session must be enabled for events of the specified type in order to receive them.
/// - operationAborted: The operation was aborted.
/// - rawWriteProtocolViolation: Violation of raw write protocol occurred during transfer.
/// - rawReadProtocolViolation: Violation of raw read protocol occurred during transfer.
/// - outputProtocolViolation: Device reported an output protocol error during transfer.
/// - inputProtocolViolation: Device reported an input protocol error during transfer.
/// - busError: Bus error occurred during transfer.
/// - operationAlreadyInProgress: Unable to queue the asynchronous operation because there is already an operation in progress.
/// - invalidSetup: Unable to start operation because setup is invalid (due to attributes being set to an inconsistent state).
/// - queueError: Unable to queue asynchronous operation.
/// - insufficientSystemResources: Insufficient system resources to perform necessary memory allocation.
/// - invalidBufferMask: Invalid buffer mask specified.
/// - ioError: Could not perform operation because of I/O error.
/// - invalidFormat: A format specifier in the format string is invalid.
/// - unsupportedFormat: A format specifier in the format string is not supported.
/// - triggerLineInUse: The specified trigger line is currently in use.
/// - unsupportedMode: The specified mode is not supported by this VISA implementation.
/// - serviceRequestNotReceived: Service request has not been received for the session.
/// - invalidAddressSpace: Invalid address space specified.
/// - invalidOffset: Invalid offset specified.
/// - invalidWidth: Invalid source or destination width specified.
/// - unsupportedOffset: Specified offset is not accessible from this hardware.
/// - nonequalSourceAndDestinationWidths: Cannot support source and destination widths that are different.
/// - sessionNotMapped: The specified session is not currently mapped.
/// - responseStillPending: A previous response is still pending, causing a multiple query error.
/// - noListeners: No Listeners condition is detected (both `NRFD` and `NDAC` are deasserted).
/// - notControllerInCharge: The interface associated with this session is not currently the controller in charge.
/// - notSystemController: The interface associated with this session is not the system controller.
/// - unsupportedOperation: The given session or object reference does not support this operation.
/// - interuptStillPending: An interrupt is still pending from a previous call.
/// - parityError: A parity error occurred during transfer.
/// - framingError: A framing error occurred during transfer.
/// - overrunError: An overrun error occurred during transfer. A character was not read from the hardware before the next character arrived.
/// - triggerNotMapped: The path from trigSrc to trigDest is not currently mapped.
/// - unsupportedAlignOffset: The specified offset is not properly aligned for the access width of the operation.
/// - invalidUserBuffer: A specified user buffer is not valid or cannot be accessed for the required size.
/// - resourceBusy: The resource is valid, but VISA cannot currently access it.
/// - unsupportedWidth: Specified width is not supported by this hardware.
/// - invalidParameter: The value of some parameter—which parameter is not known—is invalid.
/// - invalidProtocol: The protocol specified is invalid.
/// - invalidWindowSize: Invalid size of window specified.
/// - windowMapped: The specified session currently contains a mapped window.
/// - unimplementedOperation: The given operation is not implemented.
/// - invalidLength: Invalid length specified.
/// - invalidMode: The specified mode is invalid.
/// - sessionNotLocked: The current session did not have any lock on the resource.
/// - memoryNotShared: The device does not export any memory.
/// - libraryNotFound: A code library required by VISA could not be located or loaded.
/// - unsupportedInterrupt: The interface cannot generate an interrupt on the requested level or with the requested statusID value.
/// - invalidLineParameter: The value specified by the line parameter is invalid.
/// - fileAccessError: An error occurred while trying to open the specified file. Possible reasons include an invalid path or lack of access rights.
/// - fileIOError: An error occurred while performing I/O on the specified file.
/// - unsupportedLine: One of the specified lines (trigSrc or trigDest) is not supported by this VISA implementation, or the combination of lines is not a valid mapping.
/// - unsupportedMechanism: The specified mechanism is not supported by the given event type.
/// - interfaceNumberNotConfigured: The interface type is valid but the specified interface number is not configured.
/// - connectionLost: The connection for the given session has been lost.
/// - machineNotAvailable: The remote machine does not exist or is not accepting any connections.
/// - machineAccessDenied: Access to the remote machine is denied.
/// - unknownCVISAError: An unknown CVISA error status was returned from a call to CVISA. The status of this code is stored in `status`.
/// - couldNotDecode: Could not decode the message into the specified type.
/// - invalidRequestKey: The provided request key was invalid.
public enum VISAError: Error {
	// MARK: NI-VISA Defined Errors
	case systemError
	case invalidSession
	case resourceLocked
	case invalidExpressionForSearch
	case resourceNotFound
	case invalidResourceName
	case invalidAccessMode
	case timeout
	case failedToClose
	case invalidDegree
	case invalidJobIdentifier
	case unsupportedAttribute
	case unsupportedAttributeState
	case readOnlyAttribute
	case invalidLockType
	case invalidAccessKey
	case invalidEvent
	case invalidMechanism
	case handlerNotInstalled
	case invalidHandlerReference
	case invalidContext
	case queueOverflow
	case eventNotEnabled
	case operationAborted
	case rawWriteProtocolViolation
	case rawReadProtocolViolation
	case outputProtocolViolation
	case inputProtocolViolation
	case busError
	case operationAlreadyInProgress
	case invalidSetup
	case queueError
	case insufficientSystemResources
	case invalidBufferMask
	case ioError
	case invalidFormat
	case unsupportedFormat
	case triggerLineInUse
	case unsupportedMode
	case serviceRequestNotReceived
	case invalidAddressSpace
	case invalidOffset
	case invalidWidth
	case unsupportedOffset
	case nonequalSourceAndDestinationWidths
	case sessionNotMapped
	case responseStillPending
	case noListeners
	case notControllerInCharge
	case notSystemController
	case unsupportedOperation
	case interuptStillPending
	case parityError
	case framingError
	case overrunError
	case triggerNotMapped
	case unsupportedAlignOffset
	case invalidUserBuffer
	case resourceBusy
	case unsupportedWidth
	case invalidParameter
	case invalidProtocol
	case invalidWindowSize
	case windowMapped
	case unimplementedOperation
	case invalidLength
	case invalidMode
	case sessionNotLocked
	case memoryNotShared
	case libraryNotFound
	case unsupportedInterrupt
	case invalidLineParameter
	case fileAccessError
	case fileIOError
	case unsupportedLine
	case unsupportedMechanism
	case interfaceNumberNotConfigured
	case connectionLost
	case machineNotAvailable
	case machineAccessDenied
	case unknownCVISAError (status: Int32)
	// MARK: SwiftVISA Defined Errors
	case couldNotDecode
	case invalidRequestKey
}

// MARK: ViStatus Initializer
extension VISAError {
	/// Creates an error from a `ViStatus`.
	///
	/// - Parameter status: The `ViStatus` to convert to an error.
	init(_ status: ViStatus) {
		switch status {
		case VI_ERROR_SYSTEM_ERROR:
			self = .systemError
		case VI_ERROR_INV_OBJECT:
			self = .invalidSession
		case VI_ERROR_RSRC_LOCKED:
			self = .resourceLocked
		case VI_ERROR_INV_EXPR:
			self = .invalidExpressionForSearch
		case VI_ERROR_RSRC_NFOUND:
			self = .resourceNotFound
		case VI_ERROR_INV_RSRC_NAME:
			self = .invalidResourceName
		case VI_ERROR_INV_ACC_MODE:
			self = .invalidAccessMode
		case VI_ERROR_TMO:
			self = .timeout
		case VI_ERROR_CLOSING_FAILED:
			self = .failedToClose
		case VI_ERROR_INV_DEGREE:
			self = .invalidDegree
		case VI_ERROR_INV_JOB_ID:
			self = .invalidJobIdentifier
		case VI_ERROR_NSUP_ATTR:
			self = .unsupportedAttribute
		case VI_ERROR_NSUP_ATTR_STATE:
			self = .unsupportedAttributeState
		case VI_ERROR_ATTR_READONLY:
			self = .readOnlyAttribute
		case VI_ERROR_INV_LOCK_TYPE:
			self = .invalidLockType
		case VI_ERROR_INV_ACCESS_KEY:
			self = .invalidAccessKey
		case VI_ERROR_INV_EVENT:
			self = .invalidEvent
		case VI_ERROR_INV_MECH:
			self = .invalidMechanism
		case VI_ERROR_HNDLR_NINSTALLED:
			self = .handlerNotInstalled
		case VI_ERROR_INV_HNDLR_REF:
			self = .invalidHandlerReference
		case VI_ERROR_INV_CONTEXT:
			self = .invalidContext
		case VI_ERROR_QUEUE_OVERFLOW:
			self = .queueOverflow
		case VI_ERROR_NENABLED:
			self = .eventNotEnabled
		case VI_ERROR_ABORT:
			self = .operationAborted
		case VI_ERROR_RAW_WR_PROT_VIOL:
			self = .rawWriteProtocolViolation
		case VI_ERROR_RAW_RD_PROT_VIOL:
			self = .rawReadProtocolViolation
		case VI_ERROR_OUTP_PROT_VIOL:
			self = .outputProtocolViolation
		case VI_ERROR_INP_PROT_VIOL:
			self = .inputProtocolViolation
		case VI_ERROR_BERR:
			self = .busError
		case VI_ERROR_IN_PROGRESS:
			self = .operationAlreadyInProgress
		case VI_ERROR_INV_SETUP:
			self = .invalidSetup
		case VI_ERROR_QUEUE_ERROR:
			self = .queueError
		case VI_ERROR_ALLOC:
			self = .insufficientSystemResources
		case VI_ERROR_INV_MASK:
			self = .invalidBufferMask
		case VI_ERROR_IO:
			self = .ioError
		case VI_ERROR_INV_FMT:
			self = .invalidFormat
		case VI_ERROR_NSUP_FMT:
			self = .unsupportedFormat
		case VI_ERROR_LINE_IN_USE:
			self = .triggerLineInUse
		case VI_ERROR_NSUP_MODE:
			self = .unsupportedMode
		case VI_ERROR_SRQ_NOCCURRED:
			self = .serviceRequestNotReceived
		case VI_ERROR_INV_SPACE:
			self = .invalidAddressSpace
		case VI_ERROR_INV_OFFSET:
			self = .invalidOffset
		case VI_ERROR_INV_WIDTH:
			self = .invalidWidth
		case VI_ERROR_NSUP_OFFSET:
			self = .unsupportedOffset
		case VI_ERROR_NSUP_VAR_WIDTH:
			self = .nonequalSourceAndDestinationWidths
		case VI_ERROR_WINDOW_NMAPPED:
			self = .sessionNotMapped
		case VI_ERROR_RESP_PENDING:
			self = .responseStillPending
		case VI_ERROR_NLISTENERS:
			self = .noListeners
		case VI_ERROR_NCIC:
			self = .notControllerInCharge
		case VI_ERROR_NSYS_CNTLR:
			self = .notSystemController
		case VI_ERROR_NSUP_OPER:
			self = .unsupportedOperation
		case VI_ERROR_INTR_PENDING:
			self = .interuptStillPending
		case VI_ERROR_ASRL_PARITY:
			self = .parityError
		case VI_ERROR_ASRL_FRAMING:
			self = .framingError
		case VI_ERROR_ASRL_OVERRUN:
			self = .overrunError
		case VI_ERROR_TRIG_NMAPPED:
			self = .triggerNotMapped
		case VI_ERROR_NSUP_ALIGN_OFFSET:
			self = .unsupportedAlignOffset
		case VI_ERROR_USER_BUF:
			self = .invalidUserBuffer
		case VI_ERROR_RSRC_BUSY:
			self = .resourceBusy
		case VI_ERROR_NSUP_WIDTH:
			self = .unsupportedWidth
		case VI_ERROR_INV_PARAMETER:
			self = .invalidParameter
		case VI_ERROR_INV_PROT:
			self = .invalidProtocol
		case VI_ERROR_INV_SIZE:
			self = .invalidWindowSize
		case VI_ERROR_WINDOW_MAPPED:
			self = .windowMapped
		case VI_ERROR_NIMPL_OPER:
			self = .unimplementedOperation
		case VI_ERROR_INV_LENGTH:
			self = .invalidLength
		case VI_ERROR_INV_MODE:
			self = .invalidMode
		case VI_ERROR_SESN_NLOCKED:
			self = .sessionNotLocked
		case VI_ERROR_MEM_NSHARED:
			self = .memoryNotShared
		case VI_ERROR_LIBRARY_NFOUND:
			self = .libraryNotFound
		case VI_ERROR_NSUP_INTR:
			self = .unsupportedInterrupt
		case VI_ERROR_INV_LINE:
			self = .invalidLineParameter
		case VI_ERROR_FILE_ACCESS:
			self = .fileAccessError
		case VI_ERROR_FILE_IO:
			self = .fileIOError
		case VI_ERROR_NSUP_LINE:
			self = .unsupportedLine
		case VI_ERROR_NSUP_MECH:
			self = .unsupportedMechanism
		case VI_ERROR_INTF_NUM_NCONFIG:
			self = .interfaceNumberNotConfigured
		case VI_ERROR_CONN_LOST:
			self = .connectionLost
		case VI_ERROR_MACHINE_NAVAIL:
			self = .machineNotAvailable
		case VI_ERROR_NPERMISSION:
			self = .machineAccessDenied
		default:
			self = .unknownCVISAError(status: status)
		}
	}
}



