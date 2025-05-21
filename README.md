# LazyCodableKit – Safe & Flexible Decoding for Swift
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkvngwxxk%2FLazyCodableKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/kvngwxxk/LazyCodableKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkvngwxxk%2FLazyCodableKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/kvngwxxk/LazyCodableKit)

📘 [View this page in Korean](./README_KR.md)

**LazyCodableKit** provides property wrappers that gracefully decode inconsistent server values into valid Swift types.  
It supports automatic fallback handling, optional decoding and configurable logging for safer and more flexible model parsing.

## 🚀 Features
- Decode `Int`, `Double`, `String`, and `Bool` from mixed or malformed formats  
- Use fallback values when decoding fails  
- Optional variants decode to `nil` on failure  
- Lightweight and dependency-free  
- Fully compatible with Swift Concurrency (async/await)

## 📢 Logging
By default, all logs are **disabled**. Enable detailed decoding logs like this:

```swift
import LazyCodableKit

// Turn on logging for all wrappers
LazyCodableLogger.isEnabled = true

// (Optional) Also log successful conversions (✅)
// LazyCodableLogger.logOnSuccess = true

// (Optional) Customize log output destination
LazyCodableLogger.handler = { message in
    // e.g. os_log, Crashlytics, write to file
    print(message)
}
```

When enabled, you’ll see entries like:

```text
[LazyCodableKit] 📍user.age: 🔄 String("25") → Int(25)
[LazyCodableKit] 📍user.score: ⚠️ Unknown value → fallback to -1
[LazyCodableKit] 📍user.nickname: 🚫 JSON null → nil
```

- 🔄 **converted**: type coercion events  
- ⚠️ **fallback**: mismatches falling back to default  
- 🚫 **null**: JSON `null` → `nil`  
- ✅ **success**: (only if `logOnSuccess = true`)

## 📦 Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
.package(url: "https://github.com/kvngwxxk/LazyCodableKit.git", from: "1.0.0")
```

Then import:

```swift
import LazyCodableKit
```

### CocoaPods

In your `Podfile`:

```ruby
pod 'LazyCodableKit', '~> 1.0.0'
```

Then:

```bash
pod install
```

## 🛠️ Usage

### Promised (non-optional) decoding

```swift
struct User: Codable {
    @PromisedInt var age: Int
    @PromisedBool var isActive: Bool
    @PromisedString var nickname: String
    @PromisedDouble var rating: Double
}
```

### Optional decoding (fails silently)

```swift
struct User: Codable {
    @PromisedOptionalInt var age: Int?
    @PromisedOptionalBool var isActive: Bool?
    @PromisedOptionalString var nickname: String?
    @PromisedOptionalDouble var rating: Double?
}
```

## 📋 Supported Formats

| Wrapper              | Accepts                                           | Fallback (default) |
|----------------------|---------------------------------------------------|--------------------|
| `@PromisedInt`       | `Int`, `"123"`, `123.4`, `true`                   | `-1`               |
| `@PromisedBool`      | `true`, `"yes"`, `1`, `"false"`                   | `false`            |
| `@PromisedString`    | `"str"`, `123`, `true`                            | `""`               |
| `@PromisedDouble`    | `123.45`, `"123"`, `true`                         | `-1.0`             |
| `@PromisedOptional*` | Same as above, but returns `nil` on failure       | `nil`              |

## ✅ Minimum Requirements
- iOS 13+  
- macOS 11+

## 📄 License
LazyCodableKit is released under the [MIT License](LICENSE).

## 🔗 Contribution
Contributions, issues, and feature requests are welcome!  
Feel free to file an issue or submit a pull request.
