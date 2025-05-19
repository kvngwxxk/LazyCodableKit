# LazyCodableKit – Safe & Flexible Decoding for Swift

📘 [View this page in Korean](./README_KR.md)

**LazyCodableKit** provides property wrappers that gracefully decode inconsistent server values into valid Swift types.  
It supports automatic fallback handling and optional decoding for safer and more flexible model parsing.


## 🚀 Features

- Decode `Int`, `Double`, `String`, and `Bool` from mixed or malformed formats
- Use fallback values when decoding fails
- Optional variants decode to `nil` on failure
- Lightweight and dependency-free
- Fully compatible with Swift Concurrency – safe to use in async/await-based code


## 📦 Installation

### Swift Package Manager

Add the following to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/kvngwxxk/LazyCodableKit.git")
```

Or, if you want to pin to a version:

```swift
.package(
    url: "https://github.com/kvngwxxk/LazyCodableKit.git",
    from: "1.0.0"
)
```

Then import it where needed:

```swift
import LazyCodableKit
```

### CocoaPods

Add the following to your `Podfile`:

```ruby
pod 'LazyCodableKit'
```

Or specify a version:

```ruby
pod 'LazyCodableKit', '~> 1.0.0'
```

Then run:

```bash
pod install
```

## 🛠️ Usage

### Promised (non-optional) decoding

```swift
struct User: Codable {
    @PromisedInt var age: Int              // "25", 25.0, true → 1, etc.
    @PromisedBool var isActive: Bool       // "yes", 1, "false", etc.
    @PromisedString var nickname: String   // 123 → "123"
    @PromisedDouble var rating: Double     // "4.5" → 4.5
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
| `@PromisedInt`       | `Int`, `"123"`, `123.4`, `true`                   | `-1`                |
| `@PromisedBool`      | `true`, `"yes"`, `1`, `"false"`                   | `false`            |
| `@PromisedString`    | `"str"`, `123`, `true`                            | `""`               |
| `@PromisedDouble`    | `123.45`, `"123"`, `true`                         | `-1.0`              |
| `@PromisedOptional*` | Same as above, but returns `nil` on failure       | `nil`              |


## ✅ Minimum Requirements

- iOS 13+
- macOS 11+


## 📄 License

LazyCodableKit is released under the [MIT License](LICENSE).


## 🔗 Contribution

Contributions, issues, and feature requests are welcome!  
Feel free to file an issue or submit a pull request.
