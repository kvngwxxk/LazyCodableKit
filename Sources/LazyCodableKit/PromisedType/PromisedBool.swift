//
//  PromisedBool.swift
//  LazyCodableKit
//
//  Created by Kangwook Lee on 5/16/25.
//

import Foundation

/// A property wrapper that attempts to decode a `Bool` value from various formats.
///
/// This property expects a boolean value from the server.
/// If the value is provided as a `String` ("true", "1", "yes") or an `Int` (`1` or `0`), it will be interpreted accordingly.
/// If decoding fails, a fallback value will be used instead.
///
/// - Returns: Nothing
/// - Note: The fallback value defaults to `false` if not specified.
@propertyWrapper
public struct PromisedBool: Codable {
    public var wrappedValue: Bool
    private let fallback: Bool

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        var resolved: Bool? = nil

        if let bool = try? container.decode(Bool.self) {
            resolved = bool
        } else if let int = try? container.decode(Int.self) {
            resolved = int != 0
            #if DEBUG || DEV
            print("[PromisedBool] Int(\(int)) → Bool(\(resolved!))")
            #endif
        } else if let str = try? container.decode(String.self) {
            let lowered = str.lowercased()
            if ["true", "1", "yes"].contains(lowered) {
                resolved = true
            } else if ["false", "0", "no"].contains(lowered) {
                resolved = false
            }
            #if DEBUG || DEV
            print("[PromisedBool] String(\"\(str)\") → Bool(\(resolved ?? false))")
            #endif
        }

        self.fallback = false
        self.wrappedValue = resolved ?? fallback

        if resolved == nil {
            #if DEBUG || DEV
            print("[PromisedBool] Unknown value → fallback to \(fallback)")
            #endif
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
