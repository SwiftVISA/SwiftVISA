//
//  Test.swift
//  SwiftVISA
//
//  Created by Avinash on 5/14/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

// At least one .swift file must exist in the project to enable swift compiler build settings. These settings are needed to configure the module map. Do not delete this file unless there is at least one other .swift file whose target membership is to the SwiftVISA target.

// This import provides access to all types and functions of the C implementation of NI-VISA.
import CVISA

// This is an example swift wrapper around a VISA type.
public struct Session {
	fileprivate var viSession: ViSession
}


// This is an example of how the C functions can be grouped into namespaces
public enum ResourceManager {
	// This is an example of how a C function can be adapted to be more "swifty" by eliminating the need for pointers, returning a swift type, and using error handling.
	public static func openDefault() throws -> Session {
		var session = ViSession()
		let status = viOpenDefaultRM(&session)

		if status < VI_SUCCESS {
			throw Error.couldNotOpenResourceManager
		}

		return Session(viSession: session)
	}

	enum Error: Swift.Error {
		case couldNotOpenResourceManager
	}
}
