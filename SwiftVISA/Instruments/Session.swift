//
//  Session.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/28/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

import CVISA

/// A session with an instrument.
public class Session {
	/// The `ViSession` associated with this session. The `Session` type is essentailly a wrapper around this value.
	var viSession: ViSession
	
	/// Creates a `Session` from an NI-VISA `ViSession`.
	///
	/// - Parameter viSession: The NI-VISA Session.
	init(viSession: ViSession) {
		self.viSession = viSession
	}
}
