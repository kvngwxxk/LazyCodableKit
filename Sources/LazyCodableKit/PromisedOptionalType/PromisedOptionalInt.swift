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

    public init(wrappedValue: Int?) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self.wrappedValue = nil
            LazyCodableLogger.log("JSON null → nil", codingPath: decoder.codingPath, type: .null)
        } else if let int = try? container.decode(Int.self) {
            self.wrappedValue = int
            LazyCodableLogger.log("Decoded Int(\(int))", codingPath: decoder.codingPath, type: .success)
        } else if let str = try? container.decode(String.self),
                  let int = Int(str) {
            self.wrappedValue = int
            LazyCodableLogger.log("String(\"\(str)\") → Int(\(int))", codingPath: decoder.codingPath)
        } else if let double = try? container.decode(Double.self) {
            self.wrappedValue = Int(double)
            LazyCodableLogger.log("Double(\(double)) → Int(\(Int(double)))", codingPath: decoder.codingPath)
        } else if let bool = try? container.decode(Bool.self) {
            self.wrappedValue = bool ? 1 : 0
            LazyCodableLogger.log("Bool(\(bool)) → Int(\(bool ? 1 : 0))", codingPath: decoder.codingPath)
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
