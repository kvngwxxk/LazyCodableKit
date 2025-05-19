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
    private let fallback: String

    public init(wrappedValue: String = "", fallback: String = "") {
        self.wrappedValue = wrappedValue
        self.fallback = fallback
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        var resolved: String? = nil

        if let str = try? container.decode(String.self) {
            resolved = str
        } else if let int = try? container.decode(Int.self) {
            resolved = String(int)
            #if DEBUG || DEV
            print("[PromisedString] Int(\(int)) → String(\"\(resolved!)\")")
            #endif
        } else if let double = try? container.decode(Double.self) {
            resolved = String(double)
            #if DEBUG || DEV
            print("[PromisedString] Double(\(double)) → String(\"\(resolved!)\")")
            #endif
        } else if let bool = try? container.decode(Bool.self) {
            resolved = String(bool)
            #if DEBUG || DEV
            print("[PromisedString] Bool(\(bool)) → String(\"\(resolved!)\")")
            #endif
        }

        self.fallback = ""
        self.wrappedValue = resolved ?? fallback

        if resolved == nil {
            #if DEBUG || DEV
            print("[PromisedString] Unknown value → fallback to \"\(fallback)\"")
            #endif
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
