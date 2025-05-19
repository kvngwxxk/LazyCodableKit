//
//  PromisedOptionalString.swift
//  LazyCodableKit
//
//  Created by Kangwook Lee on 5/19/25.
//

import Foundation

/// A property wrapper that attempts to decode a `String?` value from various formats.
///
/// Accepts `String`, `Int`, `Double`, and `Bool` values, which are converted to a string.
/// If decoding fails, the value will be set to `nil`.
///
/// - Returns: Nothing
/// - Note: This wrapper does not use a fallback value.
@propertyWrapper
public struct PromisedOptionalString: Codable {
    public var wrappedValue: String?

    public init(wrappedValue: String? = nil) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let str = try? container.decode(String.self) {
            wrappedValue = str
        } else if let int = try? container.decode(Int.self) {
            wrappedValue = String(int)
            #if DEBUG || DEV
            print("[PromisedOptionalString] Int(\(int)) → String(\"\(wrappedValue!)\")")
            #endif
        } else if let double = try? container.decode(Double.self) {
            wrappedValue = String(double)
            #if DEBUG || DEV
            print("[PromisedOptionalString] Double(\(double)) → String(\"\(wrappedValue!)\")")
            #endif
        } else if let bool = try? container.decode(Bool.self) {
            wrappedValue = String(bool)
            #if DEBUG || DEV
            print("[PromisedOptionalString] Bool(\(bool)) → String(\"\(wrappedValue!)\")")
            #endif
        } else {
            wrappedValue = nil
            #if DEBUG || DEV
            print("[PromisedOptionalString] Unable to decode → value set to nil")
            #endif
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
