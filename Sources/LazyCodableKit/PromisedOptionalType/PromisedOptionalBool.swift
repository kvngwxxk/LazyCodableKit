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

    public init(wrappedValue: Bool?) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self.wrappedValue = nil
            LazyCodableLogger.log("JSON null → nil", codingPath: decoder.codingPath, type: .null)
        } else if let bool = try? container.decode(Bool.self) {
            self.wrappedValue = bool
            LazyCodableLogger.log("Decoded Bool(\(bool))", codingPath: decoder.codingPath, type: .success)
        } else if let int = try? container.decode(Int.self) {
            self.wrappedValue = int != 0
            LazyCodableLogger.log("Int(\(int)) → Bool(\(int != 0))", codingPath: decoder.codingPath)
        } else if let double = try? container.decode(Double.self) {
            self.wrappedValue = double != 0.0
            LazyCodableLogger.log("Double(\(double)) → Bool(\(double != 0))", codingPath: decoder.codingPath)
        } else if let str = try? container.decode(String.self) {
            let lowered = str.lowercased()
            if ["true", "1", "yes"].contains(lowered) {
                self.wrappedValue = true
            } else if ["false", "0", "no"].contains(lowered) {
                self.wrappedValue = false
            } else {
                self.wrappedValue = nil
            }
            LazyCodableLogger.log("String(\"\(str)\") → Bool(\(self.wrappedValue?.description ?? "nil"))", codingPath: decoder.codingPath)
        } else {
            self.wrappedValue = nil
            LazyCodableLogger.log("Unknown value → nil", codingPath: decoder.codingPath, type: .null)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
