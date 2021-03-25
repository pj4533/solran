// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SolRan",
    products: [
        .executable(name: "solran", targets: ["SolRan"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
        .package(path: "../SolastaKit")
    ],
    targets: [
        .target(name: "SolRan", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            .product(name: "SolastaKit", package: "SolastaKit")
        ])
    ]
)
