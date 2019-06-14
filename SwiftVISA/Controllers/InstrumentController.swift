//
//  InstrumentController.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 6/13/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

/// Types that adopt this protocol contol functionality realated to an instrument.
///
/// It is recommended to have all instrument logic handled by an instrument controller in order to segregate logic.
public protocol InstrumentController: class {
	/// The type of instrument that the controller controls.
	associatedtype Instrument: SwiftVISA.Instrument
	
	/// The instrument that the controller controls.
	var instrument: Instrument { get }
	
	/// Creates
	///
	/// - Parameter instrument: The instrument to be controlled.
	init(instrument: Instrument)
}
