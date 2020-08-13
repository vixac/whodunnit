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
        .executable(name: "WhodunnitMain", targets: ["WhodunnitMain"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Whodunnit", dependencies: [] , path: "Sources/Whodunnit"), // no test
         .target(name: "WhodunnitMain", dependencies: ["Whodunnit"] , path: "Sources/WhodunnitMain"), // no test
        .testTarget(name: "WhodunnitTests", dependencies: ["Whodunnit"], path: "Tests/WhodunnitTests")
    ]
)
