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

/// This is an example function to show how the C types and functions are imported
private func example() {
	var session = ViSession()
	let status = viOpenDefaultRM(&session)
	if status < VI_SUCCESS {
		print("Could not open the default resource manager.")
	} else {
		print("Successfully opened the default resource manager.")
	}
}
