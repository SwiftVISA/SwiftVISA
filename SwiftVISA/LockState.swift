//
//  LockState.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/28/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

public enum LockState {
	case locked (LockType)
	case unlocked
	
	public enum LockType {
		case shared (key: String)
		case exclusive
	}
}
