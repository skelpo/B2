// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "B2",
    products: [
        .library(name: "B2", targets: ["B2"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.1.0")
    ],
    targets: [
        .target(name: "B2", dependencies: ["Vapor"]),
        .testTarget(name: "B2Tests", dependencies: ["B2"]),
    ]
)