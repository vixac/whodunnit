// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Whodunnit",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "Whodunnit", targets: ["Whodunnit"]),
        .executable(name: "WhoFiles", targets: ["WhodunnitMain"]),
    ],
    dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "0.2.0")],
    targets: [
        .target(name: "Whodunnit", dependencies: [] , path: "Sources/Whodunnit"), // no test
         .target(name: "WhodunnitMain", dependencies: ["Whodunnit", "ArgumentParser"] , path: "Sources/WhodunnitMain"), // no test
        .testTarget(name: "WhodunnitTests", dependencies: ["Whodunnit"], path: "Tests/WhodunnitTests")
    ]
)
