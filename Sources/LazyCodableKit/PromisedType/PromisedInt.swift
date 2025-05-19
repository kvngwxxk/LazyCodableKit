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
/// - Note: The fallback value defaults to `0` if not specified.
@propertyWrapper
public struct PromisedInt: Codable {
    public var wrappedValue: Int
    private let fallback: Int

    public init(wrappedValue: Int = 0, fallback: Int = 0) {
        self.wrappedValue = wrappedValue
        self.fallback = fallback
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        var resolved: Int? = nil

        if let int = try? container.decode(Int.self) {
            resolved = int
        } else if let str = try? container.decode(String.self),
                  let int = Int(str) {
            resolved = int
            #if DEBUG || DEV
            print("[PromisedInt] String(\"\(str)\") → Int(\(int))")
            #endif
        } else if let double = try? container.decode(Double.self) {
            resolved = Int(double)
            #if DEBUG || DEV
            print("[PromisedInt] Double(\(double)) → Int(\(resolved!))")
            #endif
        }

        self.fallback = 0
        self.wrappedValue = resolved ?? fallback

        if resolved == nil {
            #if DEBUG || DEV
            print("[PromisedInt] Unknown value → fallback to \(fallback)")
            #endif
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
