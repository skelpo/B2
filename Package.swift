// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "B2",
    products: [
        .library(name: "B2", targets: ["B2"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "B2", dependencies: []),
        .testTarget(name: "B2Tests", dependencies: ["B2"]),
    ]
)