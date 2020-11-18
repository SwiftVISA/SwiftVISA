//
//  InstrumentManager.swift
//
//
//  Created by Connor Barnes on 11/17/20.
//

import Foundation

/// A class that is used to connect to VISA instruments.
///
/// An application uses a single shared instance of `InstrumentManager` that can be accessed by the static `shared` property.
public final class InstrumentManager {
	/// How long to wait when trying to connect to instruments for the first time.
	var connectionTimeout: TimeInterval = 2.0
	// Prevent users from creating instances of this class
	internal init() { }
}

// MARK: Singleton
extension InstrumentManager {
	/// The application's shared `InstrumentManager` instance.
	public static var shared = InstrumentManager()
}

extension InstrumentManager {
	/// Returns the instrument at the specified network address.
	/// - Parameters:
	///   - address: The network address (IPv4 or IPv6).
	///   - port: The port the instrument is connected on.
	///   - timeout: The maximum wait time when first connecting to this instrument.
	/// - Throws: If the instrument could not be found or connected to.
	/// - Returns: The instrument at the specified address.
	public func instrumentAt(
		address: String,
		port: Int, timeout:
			TimeInterval? = nil
	) throws -> MessageBasedInstrument {
		return try TCPIPInstrument(address: address,
															 port: port,
															 timeout: timeout ?? connectionTimeout)
	}
}
