// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Whodunnit",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "WhodunnitLib", targets: ["WhodunnitLib"]),
        .executable(name: "WhoFiles", targets: ["WhoFilesMain"]),
        .executable(name: "Whodunnit", targets: ["WhodunnitMain"]),
    ],
    dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "0.2.0")],
    targets: [
        .target(name: "WhodunnitLib", dependencies: [] , path: "Sources/Whodunnit"), // no test
         .target(name: "WhoFilesMain", dependencies: ["WhodunnitLib", "ArgumentParser"] , path: "Sources/WhoFilesMain"),
         .target(name: "WhodunnitMain", dependencies: ["WhodunnitLib", "ArgumentParser"] , path: "Sources/WhodunnitMain"),
        .testTarget(name: "WhodunnitTests", dependencies: ["WhodunnitLib"], path: "Tests/WhodunnitTests")
    ]
)
