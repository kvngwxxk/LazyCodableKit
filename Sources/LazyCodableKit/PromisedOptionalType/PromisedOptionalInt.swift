//
//  PromisedOptionalInt.swift
//  LazyCodableKit
//
//  Created by Kangwook Lee on 5/19/25.
//

import Foundation

/// A property wrapper that attempts to decode an `Int?` value from various formats.
///
/// Accepts `Int`, `String` (e.g. `"123"`), and `Double` (e.g. `123.99`) as valid sources.
/// If decoding fails, the value will be set to `nil`.
///
/// - Returns: Nothing
/// - Note: This wrapper does not use a fallback value.
@propertyWrapper
public struct PromisedOptionalInt: Codable {
    public var wrappedValue: Int?

    public init(wrappedValue: Int? = nil) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let int = try? container.decode(Int.self) {
            wrappedValue = int
        } else if let str = try? container.decode(String.self),
                  let int = Int(str) {
            wrappedValue = int
            #if DEBUG || DEV
            print("[PromisedOptionalInt] String(\"\(str)\") → Int(\(int))")
            #endif
        } else if let double = try? container.decode(Double.self) {
            wrappedValue = Int(double)
            #if DEBUG || DEV
            print("[PromisedOptionalInt] Double(\(double)) → Int(\(wrappedValue!))")
            #endif
        } else {
            wrappedValue = nil
            #if DEBUG || DEV
            print("[PromisedOptionalInt] Unable to decode → value set to nil")
            #endif
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
