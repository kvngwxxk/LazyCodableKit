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

    public init(wrappedValue: String?) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self.wrappedValue = nil
            LazyCodableLogger.log("JSON null → nil", codingPath: decoder.codingPath, type: .null)
        } else if let str = try? container.decode(String.self) {
            self.wrappedValue = str
            LazyCodableLogger.log("Decoded String(\(str))", codingPath: decoder.codingPath, type: .success)
        } else if let int = try? container.decode(Int.self) {
            self.wrappedValue = String(int)
            LazyCodableLogger.log("Int(\(int)) → String(\"\(String(int))\")", codingPath: decoder.codingPath)
        } else if let bool = try? container.decode(Bool.self) {
            self.wrappedValue = String(bool)
            LazyCodableLogger.log("Bool(\(bool)) → String(\"\(String(bool))\")", codingPath: decoder.codingPath)
        } else if let double = try? container.decode(Double.self) {
            self.wrappedValue = String(double)
            LazyCodableLogger.log("Double(\(double)) → String(\"\(String(double))\")", codingPath: decoder.codingPath)
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
