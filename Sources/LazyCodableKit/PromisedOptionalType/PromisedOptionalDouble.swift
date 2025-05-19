//
//  PromisedOptionalDouble.swift
//  LazyCodableKit
//
//  Created by Kangwook Lee on 5/19/25.
//

import Foundation

/// A property wrapper that attempts to decode a `Double?` value from various formats.
///
/// Accepts `Double`, `Int`, `String`, and `Bool` values which are converted to a double.
/// If decoding fails, the value will be set to `nil`.
///
/// - Returns: Nothing
/// - Note: This wrapper does not use a fallback value.
@propertyWrapper
public struct PromisedOptionalDouble: Codable {
    public var wrappedValue: Double?

    public init(wrappedValue: Double? = nil) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let double = try? container.decode(Double.self) {
            wrappedValue = double
        } else if let int = try? container.decode(Int.self) {
            wrappedValue = Double(int)
            #if DEBUG || DEV
            print("[PromisedOptionalDouble] Int(\(int)) → Double(\(wrappedValue!))")
            #endif
        } else if let str = try? container.decode(String.self),
                  let double = Double(str) {
            wrappedValue = double
            #if DEBUG || DEV
            print("[PromisedOptionalDouble] String(\"\(str)\") → Double(\(double))")
            #endif
        } else if let bool = try? container.decode(Bool.self) {
            wrappedValue = bool ? 1.0 : 0.0
            #if DEBUG || DEV
            print("[PromisedOptionalDouble] Bool(\(bool)) → Double(\(wrappedValue!))")
            #endif
        } else {
            wrappedValue = nil
            #if DEBUG || DEV
            print("[PromisedOptionalDouble] Unable to decode → value set to nil")
            #endif
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
