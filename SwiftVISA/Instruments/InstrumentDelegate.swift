//
//  InstrumentDelegate.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 6/9/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

public protocol InstrumentDelegate {
	func willClose()
	
	func didReceiveServiceRequest()
	
	func didReceiveVXIBusSignal(status: Int)
	
	func didReceiveVXIInterrupt(interruptLevel: Int, status: Int)
	
	func didReceiveVXITrigger(line: Int)
	
	func didReceivePXIInterrupt()
	
	func didReceiveBreakSignal()
	
	func ctsLineDidChange()
	
	func cdcLineDidChange()
	
	func dsrLineDidChange()
	
	func riInputDidChange()
	
	func didReceiveData()
	
	func didReceiveTerminationCharacter()
}
