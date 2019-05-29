//
// Created by Avinash on 2019-05-28.
// Copyright (c) 2019 SwiftVISA. All rights reserved.
//

import CVISA

/// A type that can communicate using the NI-VISA protocol with ASCII strings.
public protocol MessageBasedInstrument : Instrument {
	// TODO: Is this property needed? The buffer size can almost always be the maximum buffer size as specified by the NI-VISA protocol. Using a smaller buffer size provides no performance benfit, and only minimal memory benfits.
	/// The size in bytes to store incoming messages in.
	var bufferSize: Int { get set }
	/// The buffer where incoming messages are stored in.
	var buffer: UnsafeMutableRawBufferPointer { get }
}
