//
//  PromisedString.swift
//  LazyCodableKit
//
//  Created by Kangwook Lee on 5/16/25.
//

import Foundation

/// A property wrapper that attempts to decode a `String` value from various formats.
///
/// This property expects a string value from the server.
/// If the value is provided as an `Int`, `Double`, or `Bool`, it will be converted to a `String`.
/// If decoding fails, a fallback value will be used instead.
///
/// - Returns: Nothing
/// - Note: The fallback value defaults to an empty string `""` if not specified.
@propertyWrapper
public struct PromisedString: Codable {
    public var wrappedValue: String
    public static var fallback: String = ""

    public init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        var resolved: String?

        if let str = try? container.decode(String.self) {
            resolved = str
            LazyCodableLogger.log("Decoded String(\(str))", codingPath: decoder.codingPath, type: .success)
        } else if let int = try? container.decode(Int.self) {
            resolved = String(int)
            LazyCodableLogger.log("Int(\(int)) → String(\"\(resolved!)\")", codingPath: decoder.codingPath)
        } else if let double = try? container.decode(Double.self) {
            resolved = String(double)
            LazyCodableLogger.log("Double(\(double)) → String(\"\(resolved!)\")", codingPath: decoder.codingPath)
        } else if let bool = try? container.decode(Bool.self) {
            resolved = String(bool)
            LazyCodableLogger.log("Bool(\(bool)) → String(\"\(resolved!)\")", codingPath: decoder.codingPath)
        }

        let fallback = PromisedString.fallback
        self.wrappedValue = resolved ?? fallback

        if resolved == nil {
            LazyCodableLogger.log("Unknown value → fallback to \"\(fallback)\"", codingPath: decoder.codingPath, type: .fallback)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
