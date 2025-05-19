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
    private let fallback: Double

    public init(wrappedValue: Double = 0.0, fallback: Double = 0.0) {
        self.wrappedValue = wrappedValue
        self.fallback = fallback
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        var resolved: Double? = nil

        if let double = try? container.decode(Double.self) {
            resolved = double
        } else if let int = try? container.decode(Int.self) {
            resolved = Double(int)
            #if DEBUG || DEV
            print("[PromisedDouble] Int(\(int)) → Double(\(resolved!))")
            #endif
        } else if let str = try? container.decode(String.self),
                  let double = Double(str) {
            resolved = double
            #if DEBUG || DEV
            print("[PromisedDouble] String(\"\(str)\") → Double(\(double))")
            #endif
        } else if let bool = try? container.decode(Bool.self) {
            resolved = bool ? 1.0 : 0.0
            #if DEBUG || DEV
            print("[PromisedDouble] Bool(\(bool)) → Double(\(resolved!))")
            #endif
        }

        self.fallback = -1.0
        self.wrappedValue = resolved ?? fallback

        if resolved == nil {
            #if DEBUG || DEV
            print("[PromisedDouble] Unknown value → fallback to \(fallback)")
            #endif
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
