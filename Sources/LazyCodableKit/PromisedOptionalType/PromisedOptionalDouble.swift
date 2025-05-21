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

    public init(wrappedValue: Double?) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self.wrappedValue = nil
            LazyCodableLogger.log("JSON null → nil", codingPath: decoder.codingPath, type: .null)
        } else if let double = try? container.decode(Double.self) {
            self.wrappedValue = double
            LazyCodableLogger.log("Decoded Double(\(double))", codingPath: decoder.codingPath, type: .success)
        } else if let int = try? container.decode(Int.self) {
            self.wrappedValue = Double(int)
            LazyCodableLogger.log("Int(\(int)) → Double(\(Double(int)))", codingPath: decoder.codingPath)
        } else if let str = try? container.decode(String.self),
                  let double = Double(str) {
            self.wrappedValue = double
            LazyCodableLogger.log("String(\"\(str)\") → Double(\(double))", codingPath: decoder.codingPath)
        } else if let bool = try? container.decode(Bool.self) {
            self.wrappedValue = bool ? 1.0 : 0.0
            LazyCodableLogger.log("Bool(\(bool)) → Double(\(bool ? 1.0 : 0.0))", codingPath: decoder.codingPath)
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
