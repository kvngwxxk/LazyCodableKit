# LazyCodableKit – Swift를 위한 안전하고 유연한 디코딩 도구
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkvngwxxk%2FLazyCodableKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/kvngwxxk/LazyCodableKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkvngwxxk%2FLazyCodableKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/kvngwxxk/LazyCodableKit)

**LazyCodableKit**은 일관되지 않은 서버 응답 값을 유연하게 디코딩할 수 있도록 돕는 `@propertyWrapper` 기반의 Swift 라이브러리입니다.  
디코딩 실패 시 자동으로 fallback 값을 제공하거나, 옵셔널로 처리하여 더욱 안전하고 확장성 있는 모델 파싱을 구현할 수 있습니다.

## 🚀 주요 기능
- `Int`, `Double`, `String`, `Bool` 타입을 다양한 형식에서 유연하게 디코딩  
- 디코딩 실패 시 기본 fallback 값 자동 적용  
- 옵셔널 래퍼는 디코딩 실패 시 `nil` 반환  
- 의존성 없는 경량 구조  
- Swift Concurrency (async/await) 완벽 호환

## 📢 로깅 기능
기본적으로 모든 로깅은 **비활성화**되어 있습니다. 디코딩 과정을 추적하고 싶다면 다음과 같이 설정할 수 있습니다:

```swift
import LazyCodableKit

// 모든 래퍼에 대한 로깅 활성화
LazyCodableLogger.isEnabled = true

// (선택) 변환 성공 로그까지 보고 싶다면
// LazyCodableLogger.logOnSuccess = true

// (선택) 로그 출력 커스터마이징
LazyCodableLogger.handler = { message in
    print(message) // os_log, Crashlytics 등으로 변경 가능
}
```

로깅 예시:

```text
[LazyCodableKit] 📍user.age: 🔄 String("25") → Int(25)
[LazyCodableKit] 📍user.score: ⚠️ Unknown value → fallback to -1
[LazyCodableKit] 📍user.nickname: 🚫 JSON null → nil
```

- 🔄 타입 변환 로그  
- ⚠️ fallback 적용 로그  
- 🚫 null 처리 로그  
- ✅ 성공 로그 (logOnSuccess = true일 때)

## 📦 설치 방법

### Swift Package Manager

`Package.swift`에 다음을 추가하세요:

```swift
.package(url: "https://github.com/kvngwxxk/LazyCodableKit.git", from: "1.0.0")
```

그 후 다음을 import:

```swift
import LazyCodableKit
```

### CocoaPods

`Podfile`에 다음을 추가하세요:

```ruby
pod 'LazyCodableKit', '~> 1.0.0'
```

그 후:

```bash
pod install
```

## 🛠️ 사용 예시

### Promised (비옵셔널) 디코딩

```swift
struct User: Codable {
    @PromisedInt var age: Int
    @PromisedBool var isActive: Bool
    @PromisedString var nickname: String
    @PromisedDouble var rating: Double
}
```

### 옵셔널 디코딩 (실패 시 nil 반환)

```swift
struct User: Codable {
    @PromisedOptionalInt var age: Int?
    @PromisedOptionalBool var isActive: Bool?
    @PromisedOptionalString var nickname: String?
    @PromisedOptionalDouble var rating: Double?
}
```

## 📋 지원 포맷

| 래퍼                  | 허용되는 형식                               | 기본 fallback 값 |
|-----------------------|----------------------------------------------|------------------|
| `@PromisedInt`        | `Int`, `"123"`, `123.4`, `true`              | `-1`             |
| `@PromisedBool`       | `true`, `"yes"`, `1`, `"false"`              | `false`          |
| `@PromisedString`     | `"text"`, `123`, `true`                      | `""`             |
| `@PromisedDouble`     | `123.45`, `"123"`, `true`                    | `-1.0`           |
| `@PromisedOptional*`  | 위와 동일하지만 실패 시 `nil` 반환           | `nil`            |

## ✅ 최소 요구사항
- iOS 13 이상  
- macOS 11 이상

## 📄 라이선스
LazyCodableKit은 [MIT License](LICENSE)를 따릅니다.

## 🔗 기여
이슈, PR, 개선 제안 모두 환영합니다.  
커뮤니티와 함께 성장하는 오픈소스를 지향합니다.
