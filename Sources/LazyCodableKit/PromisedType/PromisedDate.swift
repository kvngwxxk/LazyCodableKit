//
//  PromisedDate.swift
//  LazyCodableKit
//
//  Created by Kangwook Lee on 5/21/25.
//
import Foundation

@propertyWrapper
public struct PromisedDate: Codable {
    public var wrappedValue: Date
    public static var fallback: Date = .distantPast

    public init(wrappedValue: Date) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
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

        let fb = PromisedDate.fallback
        self.wrappedValue = resolved ?? fb

        if resolved == nil {
            LazyCodableLogger.log("Unknown value → fallback to \(fb)", codingPath: decoder.codingPath, type: .fallback)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }

    internal static let dateFormats: [DateFormatter] = {
        let formats = [
            "yyyy-MM-dd",
            "yyyy/MM/dd",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd HH:mm:ss"
        ]
        return formats.map {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = $0
            return formatter
        }
    }()
}
