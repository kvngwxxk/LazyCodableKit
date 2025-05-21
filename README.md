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
    @PromisedDate var createdAt: Date    
}
```

### Optional decoding (fails silently)

```swift
struct User: Codable {
    @PromisedOptionalInt var age: Int?
    @PromisedOptionalBool var isActive: Bool?
    @PromisedOptionalString var nickname: String?
    @PromisedOptionalDouble var rating: Double?
    @PromisedOptionalDate var createdAt: Date?
}
```

## 📋 Supported Formats

| Wrapper              | Accepts                                           | Fallback (default) |      Notes              |
|----------------------|---------------------------------------------------|--------------------|-------------------------|
| `@PromisedInt`       | `Int`, `"123"`, `123.4`, `true`                   | `-1`               |                           |
| `@PromisedBool`      | `true`, `"yes"`, `1`, `"false"`                   | `false`            |                           |
| `@PromisedString`    | `"str"`, `123`, `true`                            | `""`               |                           |
| `@PromisedDouble`    | `123.45`, `"123"`, `true`                         | `-1.0`             |                           |
| `@PromisedDate`        | ISO8601, `"yyyy-MM-dd"`, `"yyyy-MM-dd HH:mm:ss"` | `Date.distantPast`   | Available since 1.1.0  |
| `@PromisedOptional*` | Same as above, but returns `nil` on failure       | `nil`              |                           |

## 🔍 Quick Example

Here's a full example that uses all Promised property wrappers with nested types and arrays:

```swift
struct Badge: Codable {
    @PromisedString var title: String
    @PromisedOptionalInt var level: Int?
}

struct Profile: Codable {
    @PromisedString var bio: String
    @PromisedOptionalBool var isVerified: Bool?
    @PromisedOptionalDate var birthday: Date?
}

struct User: Codable {
    @PromisedInt var id: Int
    @PromisedOptionalString var nickname: String?
    @PromisedBool var isActive: Bool
    @PromisedDouble var rating: Double
    @PromisedOptionalDouble var optionalScore: Double?
    @PromisedDate var createdAt: Date

    var profile: Profile
    var badges: [Badge]
}

let json = """
{
  "id": "1001",
  "nickname": 123,
  "isActive": "yes",
  "rating": "4.7",
  "optionalScore": null,
  "createdAt": "2023-11-20 12:34:56",
  "profile": {
    "bio": true,
    "isVerified": "no",
    "birthday": "2000-01-01"
  },
  "badges": [
    { "title": 456, "level": "3" },
    { "title": null, "level": {} }
  ]
}
""".data(using: .utf8)!

LazyCodableLogger.isEnabled = true
let user = try JSONDecoder().decode(User.self, from: json)
```

### Console
```text
[LazyCodableKit] 📍id: 🔄 String("1001") → Int(1001)
[LazyCodableKit] 📍nickname: 🔄 Int(123) → String("123")
[LazyCodableKit] 📍isActive: 🔄 String("yes") → Bool(true)
[LazyCodableKit] 📍rating: 🔄 String("4.7") → Double(4.7)
[LazyCodableKit] 📍optionalScore: 🚫 JSON null → nil
[LazyCodableKit] 📍createdAt: 🔄 String("2023-11-20 12:34:56") → Date(2023-11-20 12:34:56 +0000)
[LazyCodableKit] 📍profile.bio: 🔄 Bool(true) → String("true")
[LazyCodableKit] 📍profile.isVerified: 🔄 String("no") → Bool(false)
[LazyCodableKit] 📍profile.birthday: 🔄 String("2000-01-01") → Date(2000-01-01 00:00:00 +0000)
[LazyCodableKit] 📍badges.Index 0.title: 🔄 Int(456) → String("456")
[LazyCodableKit] 📍badges.Index 0.level: 🔄 String("3") → Int(3)
[LazyCodableKit] 📍badges.Index 1.title: ⚠️ Unknown value → fallback to ""
[LazyCodableKit] 📍badges.Index 1.level: 🚫 Unknown value → nil
```


## ✅ Minimum Requirements
- iOS 13+  
- macOS 11+

## 📄 License
LazyCodableKit is released under the [MIT License](LICENSE).

## 🔗 Contribution
Contributions, issues, and feature requests are welcome!  
Feel free to file an issue or submit a pull request.
