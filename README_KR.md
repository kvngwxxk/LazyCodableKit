# LazyCodableKit – Swift를 위한 안전하고 유연한 디코딩 도구  
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkvngwxxk%2FLazyCodableKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/kvngwxxk/LazyCodableKit)  
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkvngwxxk%2FLazyCodableKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/kvngwxxk/LazyCodableKit)

📘 [영문 문서 보기](./README.md)

**LazyCodableKit**은 일관되지 않은 서버 응답 데이터를 Swift 타입으로 안전하게 디코딩할 수 있도록 도와주는 경량 Swift 라이브러리입니다.  
자동 fallback 처리와 옵셔널 디코딩, 그리고 로깅 기능을 통해 모델 파싱을 더욱 안전하고 유연하게 구성할 수 있습니다.


## 🚀 주요 기능

- `Int`, `Double`, `String`, `Bool` 값을 다양한 포맷에서 디코딩  
- 실패 시 fallback 값 자동 적용  
- 옵셔널 래퍼는 실패 시 `nil` 반환  
- 경량 구조, 외부 의존성 없음  
- Swift Concurrency(async/await) 완벽 지원


## 📢 로깅 기능

기본적으로 로깅은 꺼져 있으며, 다음과 같이 설정해 사용할 수 있습니다:

```swift
import LazyCodableKit

// 모든 디코딩 로그 활성화
LazyCodableLogger.isEnabled = true

// (선택) 성공한 변환도 로그에 표시하고 싶다면
// LazyCodableLogger.logOnSuccess = true

// (선택) 로그 출력 커스터마이징
LazyCodableLogger.handler = { message in
    print(message) // 또는 os_log, 파일 저장 등
}
```

활성화 시 다음과 같은 로그가 출력됩니다:

```text
[LazyCodableKit] 📍user.age: 🔄 String("25") → Int(25)
[LazyCodableKit] 📍user.score: ⚠️ Unknown value → fallback to -1
[LazyCodableKit] 📍user.nickname: 🚫 JSON null → nil
```

- 🔄 변환된 값  
- ⚠️ fallback으로 대체된 값  
- 🚫 null → nil  
- ✅ 성공 로그 (logOnSuccess = true인 경우)


## 📦 설치 방법

### Swift Package Manager

```swift
.package(url: "https://github.com/kvngwxxk/LazyCodableKit.git", from: "1.0.0")
```

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


## 🛠️ 기본 사용법

### 필수 (non-optional) 디코딩

```swift
struct User: Codable {
    @PromisedInt var age: Int
    @PromisedBool var isActive: Bool
    @PromisedString var nickname: String
    @PromisedDouble var rating: Double
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

| 래퍼                  | 허용되는 형식                               | fallback 기본값 |
|-----------------------|----------------------------------------------|----------------|
| `@PromisedInt`        | `Int`, `"123"`, `123.4`, `true`              | `-1`           |
| `@PromisedBool`       | `true`, `"yes"`, `1`, `"false"`              | `false`        |
| `@PromisedString`     | `"문자열"`, `123`, `true`                    | `""`           |
| `@PromisedDouble`     | `123.45`, `"123"`, `true`                    | `-1.0`         |
| `@PromisedOptional*`  | 위와 동일하지만 실패 시 `nil`                | `nil`          |


## 🔍 빠른 예제

모든 `@Promised` 래퍼를 포함하고 중첩 구조, 배열까지 포함된 예시입니다:

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

### 콘솔

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


## ✅ 최소 요구사항

- iOS 13 이상  
- macOS 11 이상  
- Swift 5.9 이상


## 📄 라이선스

LazyCodableKit은 [MIT License](LICENSE)를 따릅니다.


## 🔗 기여하기

이슈 및 Pull Request는 언제나 환영입니다.  
사용 중 발견한 버그, 개선 아이디어, 또는 단순한 피드백도 큰 도움이 됩니다 :)
