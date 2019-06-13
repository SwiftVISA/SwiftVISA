//
//  InstrumentDelegate.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 6/9/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

protocol InstrumentDelegate {
	func willClose()
	
	func didReceiveBreakSignal()
	
	func didReceiveData()
	
	func ctsLineDidChange()
	
	func dcdLineDidChange()
	
	func dsrLineDidChange()
	
	func riInputDidAssert()
	
	func didReceiveTerminationCharacter()
	
	func willClear()
	
	func didGainControllerInCharge()
	
	func didLoseControllerInCharge()
	
	func didReceiveListenRequest()
	
	func didReceiveTalkRequest()
	
	func didReceivePXIInterrupt()
	
	func didReceiveServiceRequest()
	
	//func didReceiveTriggerInterrupt(trigger: Trigger)
	
	//func didReceiveUSBInterrupt(status: Status, data: Data)
	
	func didReceiveVXIBusSignal(status: Int)
	
	func didReceiveVXIBusInterrupt(status: Int, interruptLevel: Int)
	
	func systemFailLineWasAsserted()
	
	func systemResetLineWasAsserted()
}

extension InstrumentDelegate {
	func willClose() { }
	
	func didReceiveBreakSignal() { }
	
	func didReceiveData() { }
	
	func ctsLineDidChange() { }
	
	func dcdLineDidChange() { }
	
	func dsrLineDidChange() { }
	
	func riInputDidAssert() { }
	
	func didReceiveTerminationCharacter() { }
	
	func willClear() { }
	
	func didGainControllerInCharge() { }
	
	func didLoseControllerInCharge() { }
	
	func didReceiveListenRequest() { }
	
	func didReceiveTalkRequest() { }
	
	func didReceivePXIInterrupt() { }
	
	func didReceiveServiceRequest() { }
	
	//func didReceiveTriggerInterrupt(trigger: Trigger) { }
	
	//func didReceiveUSBInterrupt(status: Status, data: Data) { }
	
	func didReceiveVXIBusSignal(status: Int) { }
	
	func didReceiveVXIBusInterrupt(status: Int, interruptLevel: Int) { }
	
	func systemFailLineWasAsserted() { }
	
	func systemResetLineWasAsserted() { }
}

extension InstrumentProtocol {
	func registerEvents() throws {
		func handleEvent(session: ViSession, eventType: ViEventType, event: ViEvent, address: ViAddr?) -> ViStatus {
			switch UInt(eventType) {
			case VI_EVENT_ASRL_BREAK:
				//delegate?.didReceiveBreakSignal()
				break
			default:
				break
			}
			#warning("Not implemented")
			fatalError("Not implemented")
		}
		
		let handler: ViHndlr = handleEvent(session:eventType:event:address:)
		
		var null = VI_NULL
		
		for event in Self._events {
			viInstallHandler(session.viSession, ViEventType(event), handler, &null)
		}
		
	}
}
