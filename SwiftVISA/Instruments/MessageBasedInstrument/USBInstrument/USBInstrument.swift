//
//  USBInstrument.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/30/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

// TODO: Implement
public final class USBInstrument: MessageBasedInstrument, InstrumentProtocol {
	var _lockState: LockState
	
	public var bufferSize: Int
	
	public var buffer: UnsafeMutableRawBufferPointer
	
	public var session: Session
	
	public var identifier: String
	
	public var beforeClose: () -> Void
	
	public var timeout: TimeInterval
	
	public init(session: Session, identifier: String) {
		bufferSize = 20480
		buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: bufferSize, alignment: 4096)
		self.session = session
		self.identifier = identifier
		// TODO: Why can beforeClose not be nil, maybe this should be moved to a delegate?
		beforeClose = { }
		_lockState = .unlocked
		timeout = 5.0
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
    /// - Return: A tuple containing the data buffer created and the return count
    
    public func usb_control_in(requestType: Int16, requestId: Int16, requestValue: UInt16, index: UInt16, length: UInt16) throws -> (UnsafeMutablePointer<UInt8>, UInt16) {
        // todo I'm debating if we want to leave these as the specific integer types
        // (have the user explicitly know that their values have to be these to avoid
        // type conversion issues)
        #warning("not tested")
        let returnCountBuffer = UnsafeMutablePointer<ViUInt16>.allocate(capacity: 1)
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(length))
        // nil return count should really be converted to VI_NULL, but the types don't match
        let status = viUsbControlIn(session.viSession, requestType, requestId, requestValue, index, length, buffer, returnCountBuffer)
        
        if status < VI_SUCCESS {
            throw VISAError(status)
        }
        // todo I don't know enough about the USB standard to know if we should unpack the data from the buffer ourselves
        return (buffer, returnCountBuffer.pointee)
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
    
    public func usb_control_out(requestType: Int16, requestId: Int16, requestValue: UInt16, index: UInt16, length: UInt16) throws -> UnsafeMutablePointer<UInt8>{
        // todo I'm debating if we want to leave these as the specific types
        // (have the user explicitly know that their values have to be these to avoid
        // type conversion issues)
        #warning("not tested")
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(length))
        let status = viUsbControlOut(session.viSession, requestType, requestId, requestValue, index, length, buffer)
        
        if status < VI_SUCCESS {
            throw VISAError(status)
        }
        // todo same note as usb_control in on if we should unpack data
        return buffer
    }
    
}
