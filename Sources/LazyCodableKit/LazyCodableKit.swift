// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public enum LazyCodableLogger {
    public static var isEnabled: Bool = false
    public static var logOnSuccess: Bool = false
    public static var handler: (String) -> Void = { print($0) }

    public enum LogType {
        case converted   // 🔄
        case fallback    // ⚠️
        case unknown     // 💥
        case success     // ✅
        case null        // 🚫
    }

    internal static func log(
        _ message: String,
        codingPath: [CodingKey],
        type: LogType = .converted
    ) {
        guard isEnabled else { return }

        if type == .success && !logOnSuccess {
            return
        }

        let path = codingPath.map { $0.stringValue }.joined(separator: ".")
        let emoji: String
        switch type {
        case .converted: emoji = "🔄"
        case .fallback:  emoji = "⚠️"
        case .unknown:   emoji = "💥"
        case .success:   emoji = "✅"
        case .null:      emoji = "🚫"
        }

        handler("[LazyCodableKit] 📍\(path): \(emoji) \(message)")
    }
}
