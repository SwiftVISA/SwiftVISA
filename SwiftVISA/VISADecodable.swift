//
//  VISADecodable.swift
//  SwiftVISA
//
//  Created by Connor Barnes on 5/17/19.
//  Copyright © 2019 SwiftVISA. All rights reserved.
//

public protocol VISADecoder {
	associatedtype DecodingType: VISADecodable
	func decode(_ string: String) throws -> DecodingType
}

public struct VISADecodingError: Error {
	
}

public protocol DefaultableVISADecoder: VISADecoder {
	init()
}

public protocol VISADecodable {
	associatedtype DefaultVISADecoder: DefaultableVISADecoder where DefaultVISADecoder.DecodingType == Self
}

extension VISADecodable {
	public func decode<D: VISADecoder>(visaString string: String, with decoder: D) throws -> Self where D.DecodingType == Self {
		return try decoder.decode(string)
	}
	
	public func decode(visaString string: String) throws -> Self {
		let decoder = DefaultVISADecoder()
		return try decode(visaString: string, with: decoder)
	}
	
	public init<D: VISADecoder>(visaString string: String, decoder: D) throws where D.DecodingType == Self {
		self = try decoder.decode(string)
	}
	
	public init(visaString string: String) throws {
		let decoder = DefaultVISADecoder()
		try self.init(visaString: string, decoder: decoder)
	}
}

// MARK: String
extension String: VISADecodable {
	public typealias DefaultVISADecoder = DefaultVISAStringDecoder
}

public struct DefaultVISAStringDecoder: DefaultableVISADecoder {
	public typealias DecodingType = String
	
	public func decode(_ string: String) throws -> String {
		return string
	}
	
	public init() {
		
	}
}

// MARK: Int
extension Int: VISADecodable {
	public typealias DefaultVISADecoder = DefaultVISAIntDecoder
}

public struct DefaultVISAIntDecoder: DefaultableVISADecoder {
	public typealias DecodingType = Int
	
	public func decode(_ string: String) throws -> Int {
		guard let value = Int(string) else { throw VISADecodingError() }
		return value
	}
	
	public init() {
		
	}
}

// MARK: Double
extension Double: VISADecodable {
	public typealias DefaultVISADecoder = DefaultVISADoubleDecoder
}

public struct DefaultVISADoubleDecoder: DefaultableVISADecoder {
	public typealias DecodingType = Double
	
	public func decode(_ string: String) throws -> Double {
		guard let value = Double(string) else { throw VISADecodingError() }
		return value
	}
	
	public init() {
		
	}
}

// MARK: Bool
extension Bool: VISADecodable {
	public typealias DefaultVISADecoder = DefaultVISABoolDecoder
}

public struct DefaultVISABoolDecoder: DefaultableVISADecoder {
	public typealias DecodingType = Bool
	
	public func decode(_ string: String) throws -> Bool {
		guard let value = Bool(string) else { throw VISADecodingError() }
		return value
	}
	
	public init() {
		
	}
}

// MARK: Optional
extension Optional: VISADecodable where Wrapped: VISADecodable {
	public typealias DefaultVISADecoder = DefaultVISAOptionalDecoder<Wrapped>
}

public struct DefaultVISAOptionalDecoder<W: VISADecodable>: DefaultableVISADecoder {
	public typealias DecodingType = W?
	
	public func decode(_ string: String) throws -> W? {
		// FIXME: Replace this with the actual keyword for NULL in the string protocol
		if string == "NULL" {
			return nil
		}
		let decoder = W.DefaultVISADecoder()
		return try decoder.decode(string)
	}
	
	public init() {
		
	}
}
