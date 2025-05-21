# `LazyCodableKit`

**LazyCodableKit** is a lightweight Swift library that provides property wrappers for safely decoding inconsistent, mixed-format, or malformed API data into valid Swift types.

It supports automatic fallback handling, optional decoding, flexible date parsing, and configurable logging — allowing your models to be both safer and simpler.

## Overview

Many backend APIs return unpredictable data types — e.g., an `Int` field comes as a `String`, a `Bool` is sent as `1`, or a date comes in a non-ISO format like `"yyyy-MM-dd HH:mm:ss"`. Normally, this would cause Swift's `Codable` decoding to fail.

**LazyCodableKit** introduces a collection of `@propertyWrapper`s such as `@PromisedInt`, `@PromisedBool`, `@PromisedDate`, and their optional counterparts. These wrappers are designed to interpret values more leniently and ensure that your app handles messy or inconsistent server responses gracefully.

> ⚠️ These wrappers are not meant for strict schema validation — they are designed for **survivability** in environments where APIs are inconsistent, underdocumented, or in transition.

## Usage

### Non-Optional Decoding

Use non-optional wrappers when you want decoding to **always succeed**, even if the value is malformed — a fallback will be applied.

```swift
struct User: Codable {
    @PromisedInt var age: Int
    @PromisedBool var isActive: Bool
    @PromisedString var nickname: String
    @PromisedDouble var rating: Double
    @PromisedDate var createdAt: Date
}
```

### Optional Decoding

Use `@PromisedOptional*` when the field can be missing or invalid and you’d prefer to receive `nil` instead of a fallback.

```swift
struct User: Codable {
    @PromisedOptionalInt var age: Int?
    @PromisedOptionalBool var isActive: Bool?
    @PromisedOptionalString var nickname: String?
    @PromisedOptionalDouble var rating: Double?
    @PromisedOptionalDate var createdAt: Date?
}
```

### Date Parsing

`@PromisedDate` and `@PromisedOptionalDate` support multiple common formats:

- `yyyy-MM-dd`
- `yyyy-MM-dd HH:mm:ss`
- ISO8601 (e.g., `2024-05-20T13:00:00Z`)

If parsing fails:

- `PromisedDate` uses `.distantPast`  
- `PromisedOptionalDate` returns `nil`

## Customizing Fallbacks

All non-optional wrappers expose a public static `fallback` property.

```swift
PromisedInt.fallback = 0
PromisedDouble.fallback = 0.0
PromisedDate.fallback = Date(timeIntervalSince1970: 0)
```

This allows you to customize behavior **globally** depending on your project’s tolerance.

## Logging

Enable logging to see exactly how values are handled during decoding.

```swift
LazyCodableLogger.isEnabled = true

// Optional: also log successful conversions
LazyCodableLogger.logOnSuccess = true

// Optional: customize output
LazyCodableLogger.handler = { message in
    print(message)
}
```

Example log output:

```text
[LazyCodableKit] 📍user.age: 🔄 String("25") → Int(25)
[LazyCodableKit] 📍user.nickname: 🚫 JSON null → nil
[LazyCodableKit] 📍user.createdAt: 🔄 String("2023-12-01 12:00:00") → Date(...)
```

Legend:
- 🔄 Type coercion
- ⚠️ Fallback used
- 🚫 Decoded as `nil`
- ✅ Successful decoding (only if `logOnSuccess` is enabled)

## Supported Wrappers

| Wrapper                    | Swift Type | Accepts Formats                                            | Fallback           |
|----------------------------|------------|------------------------------------------------------------|--------------------|
| `@PromisedInt`             | `Int`      | `Int`, `"123"`, `123.4`, `true`, `false`                   | `-1`               |
| `@PromisedOptionalInt`     | `Int?`     | Same as above                                              | `nil`              |
| `@PromisedDouble`          | `Double`   | `Double`, `"123.4"`, `true`, `false`                       | `-1.0`             |
| `@PromisedOptionalDouble`  | `Double?`  | Same as above                                              | `nil`              |
| `@PromisedBool`            | `Bool`     | `Bool`, `1`, `0`, `"yes"`, `"no"`, `"true"`, `"false"`     | `false`            |
| `@PromisedOptionalBool`    | `Bool?`    | Same as above                                              | `nil`              |
| `@PromisedString`          | `String`   | Any JSON value convertible to `String`                     | `""`               |
| `@PromisedOptionalString`  | `String?`  | Same as above                                              | `nil`              |
| `@PromisedDate`            | `Date`     | `"yyyy-MM-dd"`, `"yyyy-MM-dd HH:mm:ss"`, ISO8601           | `.distantPast`     |
| `@PromisedOptionalDate`    | `Date?`    | Same as above                                              | `nil`              |

## Complete Example

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

let json = \"\"\"
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
\"\"\".data(using: .utf8)!

LazyCodableLogger.isEnabled = true
let user = try JSONDecoder().decode(User.self, from: json)
```

### Sample Output

```text
[LazyCodableKit] 📍id: 🔄 String("1001") → Int(1001)
[LazyCodableKit] 📍nickname: 🔄 Int(123) → String("123")
[LazyCodableKit] 📍isActive: 🔄 String("yes") → Bool(true)
[LazyCodableKit] 📍rating: 🔄 String("4.7") → Double(4.7)
[LazyCodableKit] 📍optionalScore: 🚫 JSON null → nil
[LazyCodableKit] 📍createdAt: 🔄 String("2023-11-20 12:34:56") → Date(...)
[LazyCodableKit] 📍profile.bio: 🔄 Bool(true) → String("true")
[LazyCodableKit] 📍profile.isVerified: 🔄 String("no") → Bool(false)
[LazyCodableKit] 📍profile.birthday: 🔄 String("2000-01-01") → Date(...)
[LazyCodableKit] 📍badges.Index 0.title: 🔄 Int(456) → String("456")
[LazyCodableKit] 📍badges.Index 0.level: 🔄 String("3") → Int(3)
[LazyCodableKit] 📍badges.Index 1.title: ⚠️ Unknown value → fallback to ""
[LazyCodableKit] 📍badges.Index 1.level: 🚫 Unknown value → nil
```

## Installation

### Swift Package Manager

```swift
.package(url: "https://github.com/kvngwxxk/LazyCodableKit.git", from: "1.1.1")
```

Import where needed:

```swift
import LazyCodableKit
```

### CocoaPods

```ruby
pod 'LazyCodableKit', '~> 1.1.1'
```

Then run:

```bash
pod install
```

## Requirements

- iOS 13+
- macOS 11+
- Swift 5.9+

## License

LazyCodableKit is released under the MIT License.

## Contributions

Contributions, issues, and pull requests are welcome!  
Please feel free to file a bug, suggest a feature, or just say hi.

---
_Visit [GitHub Issues](https://github.com/kvngwxxk/LazyCodableKit/issues) for questions or discussion._
