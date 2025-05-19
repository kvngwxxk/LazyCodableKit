//
//  PromisedOptionalBool.swift
//  LazyCodableKit
//
//  Created by Kangwook Lee on 5/19/25.
//

import Foundation

/// A property wrapper that attempts to decode a `Bool?` value from various formats.
///
/// Accepts `Bool`, `Int`, and `String` (e.g. `"true"`, `"1"`, `"yes"`) as valid sources.
/// If decoding fails, the value will be set to `nil`.
///
/// - Returns: Nothing
/// - Note: This wrapper does not use a fallback value.
@propertyWrapper
public struct PromisedOptionalBool: Codable {
    public var wrappedValue: Bool?

    public init(wrappedValue: Bool? = nil) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        var resolved: Bool? = nil

        if let bool = try? container.decode(Bool.self) {
            resolved = bool
        } else if let int = try? container.decode(Int.self) {
            resolved = int != 0
            #if DEBUG || DEV
            print("[PromisedOptionalBool] Int(\(int)) → Bool(\(resolved!))")
            #endif
        } else if let str = try? container.decode(String.self) {
            let lowered = str.lowercased()
            if ["true", "1", "yes"].contains(lowered) {
                resolved = true
            } else if ["false", "0", "no"].contains(lowered) {
                resolved = false
            }
            #if DEBUG || DEV
            print("[PromisedOptionalBool] String(\"\(str)\") → Bool(\(resolved ?? false))")
            #endif
        }

        wrappedValue = resolved

        if resolved == nil {
            #if DEBUG || DEV
            print("[PromisedOptionalBool] Unable to decode → value set to nil")
            #endif
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
