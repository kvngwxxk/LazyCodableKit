# `LazyCodableKit`

**LazyCodableKit** is a lightweight Swift library that provides property wrappers for safely decoding inconsistent, mixed-format, or malformed API data into valid Swift types.

It supports automatic fallback handling, optional decoding, and configurable logging, allowing your models to be both safer and simpler.

---

## Overview

Many backend APIs return unpredictable data types — e.g., an `Int` field comes as a `String`, a `Bool` is sent as `1`, or a field is simply `null`.

Normally, this would crash your Swift `Codable` decoding.

**LazyCodableKit** solves this by introducing `@propertyWrapper`s like `@PromisedInt`, `@PromisedBool`, and their optional variants like `@PromisedOptionalInt`, allowing you to decode safely even from garbage responses.

---

## Usage

### Non-Optional Decoding

Use standard wrappers like `@PromisedInt`, `@PromisedBool`, etc., when you want decoding to succeed even with type mismatch, using fallback values.

```swift
struct User: Codable {
    @PromisedInt var age: Int              // "25", 25.0, true → 1, etc.
    @PromisedBool var isActive: Bool       // "yes", 1, "false", etc.
    @PromisedString var nickname: String   // 123 → "123"
    @PromisedDouble var rating: Double     // "4.5" → 4.5
}
```

If decoding fails, default fallback values are used instead.

---

### Optional Decoding

Use `@PromisedOptional*` wrappers when decoding should silently return `nil` on failure.

```swift
struct User: Codable {
    @PromisedOptionalInt var age: Int?
    @PromisedOptionalBool var isActive: Bool?
    @PromisedOptionalString var nickname: String?
    @PromisedOptionalDouble var rating: Double?
}
```

This is useful for optional fields where a failure shouldn't affect decoding of the rest of the model.

---

## Logging

Starting from version 1.1.0, you can enable logging to see how LazyCodableKit handled decoding at runtime.

```swift
LazyCodableLogger.isEnabled = true
LazyCodableLogger.logOnSuccess = true // Optional
LazyCodableLogger.handler = { print($0) }
```

You'll see logs like:

```text
[LazyCodableKit] 📍user.age: 🔄 String("25") → Int(25)
[LazyCodableKit] 📍user.score: ⚠️ Unknown value → fallback to -1
[LazyCodableKit] 📍user.nickname: 🚫 JSON null → nil
```

- 🔄 Type conversion
- ⚠️ Fallback used
- 🚫 Decoded as `nil`
- ✅ Success (only if `logOnSuccess` is true)

---

## Supported Formats

| Wrapper                 | Accepts                                       | Fallback on Failure |
|-------------------------|-----------------------------------------------|---------------------|
| `@PromisedInt`          | `Int`, `"123"`, `123.4`, `true`, `false`      | `-1`                |
| `@PromisedBool`         | `true`, `false`, `"yes"`, `"no"`, `1`, `0`    | `false`             |
| `@PromisedString`       | Any value convertible to string               | `""`                |
| `@PromisedDouble`       | `Double`, `"123.4"`, `true`, `false`          | `-1.0`              |
| `@PromisedOptional*`    | Same as above                                 | `nil`               |

---

## Installation

### Swift Package Manager

```swift
.package(url: "https://github.com/kvngwxxk/LazyCodableKit.git", from: "1.0.0")
```

Then import it:

```swift
import LazyCodableKit
```

### CocoaPods

```ruby
pod 'LazyCodableKit', '~> 1.0.0'
```

```bash
pod install
```

---

## Requirements

- iOS 13+
- macOS 11+
- Swift 5.9+

---

## License

LazyCodableKit is released under the MIT License.

---

## Contributions

Issues and PRs are welcome.  
Please feel free to file a bug, suggest a feature, or just say hi.
