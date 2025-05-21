//
//  PromisedOptionalDate.swift
//  LazyCodableKit
//
//  Created by Kangwook Lee on 5/21/25.
//

import Foundation

@propertyWrapper
public struct PromisedOptionalDate: Codable {
    public var wrappedValue: Date?

    public init(wrappedValue: Date?) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self.wrappedValue = nil
            LazyCodableLogger.log("Decoded null → nil", codingPath: decoder.codingPath, type: .null)
            return
        }

        var resolved: Date? = nil

        if let timestamp = try? container.decode(Double.self) {
            resolved = Date(timeIntervalSince1970: timestamp)
            LazyCodableLogger.log("Double timestamp(\(timestamp)) → Date(\(resolved!))", codingPath: decoder.codingPath)
        } else if let timestampStr = try? container.decode(String.self),
                  let tsDouble = Double(timestampStr) {
            resolved = Date(timeIntervalSince1970: tsDouble)
            LazyCodableLogger.log("String timestamp(\"\(timestampStr)\") → Date(\(resolved!))", codingPath: decoder.codingPath)
        } else if let dateStr = try? container.decode(String.self) {
            resolved = PromisedDate.dateFormats
                .compactMap { $0.date(from: dateStr) }
                .first

            if let resolved = resolved {
                LazyCodableLogger.log("String(\"\(dateStr)\") → Date(\(resolved))", codingPath: decoder.codingPath)
            }
        }

        self.wrappedValue = resolved

        if resolved == nil {
            LazyCodableLogger.log("Unknown value → nil", codingPath: decoder.codingPath, type: .null)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

