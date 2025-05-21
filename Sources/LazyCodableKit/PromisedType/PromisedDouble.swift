//
//  PromisedDouble.swift
//  LazyCodableKit
//
//  Created by Kangwook Lee on 5/16/25.
//

import Foundation

/// A property wrapper that attempts to decode a `Double` value from various formats.
///
/// This property expects a double-precision floating-point value from the server.
/// If the value is provided as a `String`, `Int`, or `Bool`, it will be converted to a `Double`.
/// If decoding fails, a fallback value will be used instead.
///
/// - Returns: Nothing
/// - Note: The fallback value defaults to `-1.0` if not specified.
@propertyWrapper
public struct PromisedDouble: Codable {
    public var wrappedValue: Double
    public static var fallback: Double = -1.0

    public init(wrappedValue: Double) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        var resolved: Double? = nil

        if let double = try? container.decode(Double.self) {
            resolved = double
            LazyCodableLogger.log("Decoded Double(\(double))", codingPath: decoder.codingPath, type: .success)
        } else if let int = try? container.decode(Int.self) {
            resolved = Double(int)
            LazyCodableLogger.log("Int(\(int)) → Double(\(resolved!))", codingPath: decoder.codingPath)
        } else if let str = try? container.decode(String.self),
                  let double = Double(str) {
            resolved = double
            LazyCodableLogger.log("String(\"\(str)\") → Double(\(double))", codingPath: decoder.codingPath)
        } else if let bool = try? container.decode(Bool.self) {
            resolved = bool ? 1.0 : 0.0
            LazyCodableLogger.log("Bool(\(bool)) → Double(\(resolved!))", codingPath: decoder.codingPath)
        }

        let fallback = PromisedDouble.fallback
        self.wrappedValue = resolved ?? fallback

        if resolved == nil {
            LazyCodableLogger.log("Unknown value → fallback to \(fallback)", codingPath: decoder.codingPath, type: .fallback)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
