# LazyCodableKit – Swift를 위한 안전하고 유연한 디코딩 도구

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkvngwxxk%2FLazyCodableKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/kvngwxxk/LazyCodableKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkvngwxxk%2FLazyCodableKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/kvngwxxk/LazyCodableKit)

**LazyCodableKit**은 일관되지 않은 서버 응답 값을 유연하게 디코딩할 수 있도록 돕는 `@propertyWrapper` 기반의 라이브러리입니다.  
디코딩 실패 시 자동으로 fallback 값을 제공하거나, 옵셔널로 처리하여 더욱 안전하고 확장성 있는 모델 파싱을 구현할 수 있습니다.


## 🚀 주요 기능

- `Int`, `Double`, `String`, `Bool` 타입을 다양한 형식에서 유연하게 디코딩
- 디코딩 실패 시 기본 fallback 값 자동 적용
- 옵셔널 래퍼는 디코딩 실패 시 `nil` 반환
- 의존성 없는 경량 구조
- Swift Concurrency 기반 코드에서도 안전하게 사용 가능 (async/await 환경 호환).


## 📦 설치 방법

### Swift Package Manager

`Package.swift` 파일의 `dependencies` 항목에 다음을 추가하세요:

```swift
.package(url: "https://github.com/kvngwxxk/LazyCodableKit.git")
```

또는 버전을 고정하려면:

```swift
.package(
    url: "https://github.com/kvngwxxk/LazyCodableKit.git",
    from: "1.0.0"
)
```

사용할 파일 상단에 다음을 import 해주세요:

```swift
import LazyCodableKit
```

### CocoaPods

`Podfile`에 다음 중 하나를 추가하세요:

```ruby
pod 'LazyCodableKit'
```

또는 버전을 명시하려면:

```ruby
pod 'LazyCodableKit', '~> 1.0.0'
```

그 후 실행:

```bash
pod install
```

## 🛠️ 사용법

### Promised (비옵셔널) 디코딩

```swift
struct User: Codable {
    @PromisedInt var age: Int              // "25", 25.0, true → 1 등
    @PromisedBool var isActive: Bool       // "yes", 1, "false" 등
    @PromisedString var nickname: String   // 123 → "123"
    @PromisedDouble var rating: Double     // "4.5" → 4.5
}
```

### 옵셔널 디코딩 (실패 시 `nil`)

```swift
struct User: Codable {
    @PromisedOptionalInt var age: Int?
    @PromisedOptionalBool var isActive: Bool?
    @PromisedOptionalString var nickname: String?
    @PromisedOptionalDouble var rating: Double?
}
```


## 📋 지원 포맷

| 래퍼                  | 지원되는 입력 형식                                | 기본 fallback 값   |
|-----------------------|--------------------------------------------------|--------------------|
| `@PromisedInt`        | `Int`, `"123"`, `123.4`, `true` 등               | `-1`                |
| `@PromisedBool`       | `true`, `"yes"`, `1`, `"false"` 등               | `false`            |
| `@PromisedString`     | `"문자열"`, `123`, `true` 등                     | `""`               |
| `@PromisedDouble`     | `123.45`, `"123"`, `true` 등                     | `-1.0`              |
| `@PromisedOptional*`  | 위와 동일, 실패 시 `nil` 반환                    | `nil`              |


## ✅ 최소 요구사항

- iOS 13 이상
- macOS 11 이상


## 📄 라이선스

LazyCodableKit은 [MIT 라이선스](LICENSE)를 따릅니다.


## 🔗 기여하기

이슈 제보나 기능 제안, PR 기여는 언제든 환영합니다.  
오픈소스 생태계에서 유용한 도구가 될 수 있도록 여러분의 참여를 기다립니다.
