// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LazyCodableKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "LazyCodableKit",
            targets: ["LazyCodableKit"]
        )
    ],
    targets: [
        .target(
            name: "LazyCodableKit",
            path: "Sources/LazyCodableKit"
        ),
        .testTarget(
            name: "LazyCodableKitTests",
            dependencies: ["LazyCodableKit"],
            path: "Tests/LazyCodableKitTests"
        )
    ]
)
