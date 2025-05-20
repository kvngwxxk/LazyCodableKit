# ``LazyCodableKit``

**LazyCodableKit** is a lightweight Swift library designed to make decoding messy or inconsistent JSON responses more resilient.

It provides a set of `@propertyWrapper`s that automatically convert misformatted or mis-typed values (like `"123"` → `Int`, `true` → `1`, etc.) into expected Swift types, avoiding crashes and unnecessary decoding logic.

## Overview

Many backend APIs do not strictly follow the contract defined in the documentation. A value that should be an `Int` might come as a `String`, a `Bool`, or even `null`. This causes `Codable` to throw decoding errors, often crashing the app or requiring custom decoding for every such field.

LazyCodableKit solves this by wrapping each field with a `@Promised` property wrapper that handles type mismatches gracefully and applies fallback values when needed.

## Topics

### Property Wrappers

- ``PromisedInt``
- ``PromisedDouble``
- ``PromisedBool``
- ``PromisedString``

### Optional Versions

All wrappers support optional decoding. You can use them like this:

```swift
struct Model: Decodable {
    @PromisedInt var requiredInt: Int
    @PromisedInt? var optionalInt: Int?
}
```

## Usage

### Basic Example

```swift
struct User: Decodable {
    @PromisedInt var age: Int
    @PromisedBool var isActive: Bool
    @PromisedString var name: String
}
```

If the API returns:

```json
{
  "age": "30",
  "isActive": 1,
  "name": 1234
}
```

`LazyCodableKit` will decode this safely as:

- `age` = 30
- `isActive` = true
- `name` = "1234"

### Default Fallbacks

If a field fails to decode (e.g., malformed or null), the wrapper provides a reasonable default:

| Wrapper          | Default Fallback |
|------------------|------------------|
| `PromisedInt`    | `-1`             |
| `PromisedDouble` | `-1.0`           |
| `PromisedBool`   | `false`          |
| `PromisedString` | `""`             |

Optional versions will result in `nil` instead.

## Motivation

This library was created out of frustration with constantly defending against bad server data. Instead of writing boilerplate `init(from:)` decoding for each model, `LazyCodableKit` lets you annotate only the fields that are likely to break, or apply it universally across your models for defensive decoding.

## Installation

You can install LazyCodableKit via Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/kvngwxxk/LazyCodableKit", from: "1.0.2")
]
```

And import in your source file:

```swift
import LazyCodableKit
```

## License

LazyCodableKit is available under the MIT license.

## Contributions

Issues, PRs, and feedback are welcome! This project aims to remain lightweight and focused on defensive decoding with no additional dependencies.
