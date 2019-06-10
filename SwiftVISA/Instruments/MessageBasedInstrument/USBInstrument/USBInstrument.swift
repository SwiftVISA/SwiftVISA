//
//  USBInstrument.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/30/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

public final class USBInstrument: MessageBasedInstrument, InstrumentProtocol {
	static var _events: [UInt] = [VI_EVENT_SERVICE_REQ, VI_EVENT_USB_INTR]
	
	var _lockState: LockState
	
	public var bufferSize: Int
	
	public var buffer: UnsafeMutableRawBufferPointer
	
	public var session: Session
	
	public var identifier: String
	
	public var timeout: TimeInterval
	
	public var delegate: InstrumentDelegate?
	
	public var dispatchQueue: DispatchQueue
	
	public init(session: Session, identifier: String) {
		bufferSize = 20480
		buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: bufferSize, alignment: 4096)
		self.session = session
		self.identifier = identifier
		_lockState = .unlocked
		timeout = 5.0
		dispatchQueue = DispatchQueue(label: identifier, qos: .userInitiated)
	}
    /// Performs a USB control pipe transfer from the device
    /// This operation is intended for people familiar with the USB Protocol
    /// and assumes that you will do buffer management yourself
    /// - Parameters:
    ///   - requestType: bmRequestType; Bitmap specifying the request type in the USB standard
    ///   - requestId: bRequest of setup stage in the USB standard
    ///   - requestValue: wValue param of setup stage in the USB standard
    ///   - index: wIndex parameter of setup stage in the USB standard (typically index of interface or endpoint)
    ///   - length: wLength parameter of setup stage in the USB standard; also specifies the amount of data elements to receive data from optional data stage of the control transfer
    /// - Return: The data buffer received from the optional data stage of the control transfer
    public func usb_control_in(requestType: Int16, requestId: Int16, requestValue: UInt16, index: UInt16, length: UInt16) throws -> Data {
        #warning("not tested")
        let returnCountBuffer = UnsafeMutablePointer<ViUInt16>.allocate(capacity: 1)
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(length))
        // nil return count should really be converted to VI_NULL, but the types don't match
        let status = viUsbControlIn(session.viSession, requestType, requestId, requestValue, index, length, buffer, returnCountBuffer)
        
        if status < VI_SUCCESS {
            throw VISAError(status)
        }
		let result = Data(bytes: buffer, count: Int(returnCountBuffer.pointee))
        // todo I don't know enough about the USB standard to know if we should unpack the data from the buffer ourselves
        return result
    }
    
    /// Performs a USB control pipe transfer from the device
    /// This operation is intended for people familiar with the USB Protocol
    /// and assumes that you will do buffer management yourself
    /// - Parameters:
    ///   - requestType: bmRequestType; Bitmap specifying the request type in the USB standard
    ///   - requestId: bRequest of setup stage in the USB standard
    ///   - requestValue: wValue param of setup stage in the USB standard
    ///   - index: wIndex parameter of setup stage in the USB standard (typically index of interface or endpoint)
    ///   - length: wLength parameter of setup stage in the USB standard; also specifies the size of the data buffer to send from optional data stage of the control transfer
    ///   - buffer: data buffer that sends data from the optional data stage of the control transfer. Ignored if length is 0.
	/// - Returns: The data buffer that sends the data from the optional data stage of the control transfer.
    public func usb_control_out(requestType: Int16, requestId: Int16, requestValue: UInt16, index: UInt16, length: UInt16) throws -> Data {
        #warning("not tested")
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(length))
		let result = Data(bytes: buffer, count: Int(length))
        let status = viUsbControlOut(session.viSession, requestType, requestId, requestValue, index, length, buffer)
        
        if status < VI_SUCCESS {
            throw VISAError(status)
        }
        // todo same note as usb_control in on if we should unpack data
        return result
    }
    
}
