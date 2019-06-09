//
//  GPIBInstrument.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/30/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//
import CVISA

// TODO: Implement
public final class GPIBInstrument: MessageBasedInstrument, InstrumentProtocol {
	static var _events: [UInt] = [VI_EVENT_SERVICE_REQ]
	
	var _lockState: LockState
	
	public var bufferSize: Int
	
	public var buffer: UnsafeMutableRawBufferPointer
	
	public var session: Session
	
	public var identifier: String
	
	public var timeout: TimeInterval
	
	public var delegate: InstrumentDelegate?
	
	public init(session: Session, identifier: String) {
		#warning("Not implemented")
        self.session = session
        self.identifier = identifier
		fatalError("Not implemented")
	}
    
    /// Sends GPIB command bytes to the device.
    /// - Parameters:
    ///   - data: A buffer of UInt8s specifying GPIB commands
    ///   - length: the length of the data buffer
    /// - Return: Amount of written bytes
    public func sendCommand(data: ViPByte, length: UInt32) throws -> UInt32 {
        #warning("Needs Unit Testing")
        let retBuffer = UnsafeMutablePointer<ViUInt32>.allocate(capacity: 1)
        let status = viGpibCommand(session.viSession, data, length, retBuffer)
        guard status >= VI_SUCCESS else {
            throw VISAError(status)
        }
        return retBuffer.pointee
    }
    
    public func controlAtn(mode: UInt16) throws {
        #warning("Needs Unit Testing")
        // definition of cvisa constants in swiftvisa would be nice
        // this is also part of a GPIB mixin separate from the class
        let status = viGpibControlATN(session.viSession, mode)
        guard status >= VI_SUCCESS else {
            throw VISAError(status)
        }
    }
    
    public func controlRen(mode: UInt16) throws {
        #warning("Needs Unit Testing")
        // definition of cvisa constants in swiftvisa would be nice
        // this is also part of a ControlRen mixin separate from the class that is also used for some message based stuff
        let status = viGpibControlREN(session.viSession, mode)
        if status < VI_SUCCESS{
            throw VISAError(status)
        }
    }
    
    public func passControl(primaryAddress: UInt16, secondaryAddress: UInt16) throws {
        #warning("Needs Unit Testing")
        // gpib mixin
        let status = viGpibPassControl(session.viSession, primaryAddress, secondaryAddress)
        if status < VI_SUCCESS {
            throw VISAError(status)
        }
    }
    
    public func sendIfc() throws {
        #warning("Needs Unit Testing")
        // gpib mixin
        let status = viGpibSendIFC(session.viSession)
        if status < VI_SUCCESS {
            throw VISAError(status)
        }
    }
    
    /// Waits for a serial request coming from the instrument
    /// doesn't end when another instrument signals for an SRQ
    
    /// Keep in mind that this is a BLOCKING operation
    public func waitForSrq(timeout: UInt? = 25000) throws {
        #warning("Needs Unit Testing")
        // this function seems to have something to do with enabling events
        // todo convert this to swiftvisa calls so we can standardize/remove status checks
        // also these type casts are killing me
        let enableStatus = viEnableEvent(session.viSession, ViEventType(VI_EVENT_SERVICE_REQ), ViUInt16(VI_QUEUE), ViUInt32(VI_NULL))
        
        guard enableStatus >= VI_SUCCESS else {
            throw VISAError(enableStatus)
        }
        
        let startTime = Double(DispatchTime.now().uptimeNanoseconds) / 1e-6
        var subTimeout = timeout
        
        while true {
            if subTimeout == nil {
                subTimeout = VI_TMO_INFINITE
            } else {
                // todo make sure my timing stuff is a correct conversion from python
                let current = Double(DispatchTime.now().uptimeNanoseconds) / 1e-6
                var adjustedTimeout = Int(startTime + Double(subTimeout!) - current)
                if adjustedTimeout < 0 {
                    adjustedTimeout = 0
                }
                
                let outEventType = ViPEventType.allocate(capacity: 1)
                let outContext = ViPEvent.allocate(capacity: 1)

                let waitStatus = viWaitOnEvent(session.viSession, ViEventType(VI_EVENT_SERVICE_REQ), UInt32(adjustedTimeout), outEventType, outContext)
                
                guard waitStatus >= VI_SUCCESS else {
                    throw VISAError(enableStatus)
                }
                outEventType.deallocate()
                outContext.deallocate()
                let stbPointer = UnsafeMutablePointer<ViUInt16>.allocate(capacity: 1)
                let stbReadStatus = viReadSTB(session.viSession, stbPointer)
                
                guard stbReadStatus >= VI_SUCCESS else {
                    throw VISAError(stbReadStatus)
                }
                // oh god why
                // this may or may not be wrong -- it's based on the truthyness of the left hand side in Python which I think is 0 is false, anything else true
                if Int(stbPointer.pointee) & 0x40 != 0 {
                    break
                }
            }
            
        }
        viDiscardEvents(session.viSession, ViEventType(VI_EVENT_SERVICE_REQ), ViUInt16(VI_QUEUE))
    }
}
