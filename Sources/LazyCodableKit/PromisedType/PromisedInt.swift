//
//  PromisedInt.swift
//  LazyCodableKit
//
//  Created by Kangwook Lee on 5/16/25.
//
import Foundation

/// A property wrapper that attempts to decode an `Int` value from various formats.
///
/// This property expects an integer value from the server.
/// If the value is provided as a `String` or `Double`, it will be converted to an `Int`.
/// If decoding fails, a fallback value will be used instead.
///
/// - Returns: Nothing
/// - Note: The fallback value defaults to `-1` if not specified.
@propertyWrapper
public struct PromisedInt: Codable {
    public var wrappedValue: Int
    public static var fallback: Int = -1

    public init(wrappedValue: Int) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        var resolved: Int? = nil

        if let int = try? container.decode(Int.self) {
            resolved = int
            LazyCodableLogger.log("Decoded Int(\(int))", codingPath: decoder.codingPath, type: .success)
        } else if let str = try? container.decode(String.self),
                  let int = Int(str) {
            resolved = int
            LazyCodableLogger.log("String(\"\(str)\") → Int(\(int))", codingPath: decoder.codingPath)
        } else if let double = try? container.decode(Double.self) {
            resolved = Int(double)
            LazyCodableLogger.log("Double(\(double)) → Int(\(resolved!))", codingPath: decoder.codingPath)
        } else if let bool = try? container.decode(Bool.self) {
            resolved = bool ? 1 : 0
            LazyCodableLogger.log("Bool(\(bool)) → Int(\(resolved!))", codingPath: decoder.codingPath)
        }

        let fb = PromisedInt.fallback
        self.wrappedValue = resolved ?? fb

        if resolved == nil {
            LazyCodableLogger.log("Unknown value → fallback to \(fb)", codingPath: decoder.codingPath, type: .fallback)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
