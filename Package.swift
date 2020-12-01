// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "aoc-2020",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "Utils",
            targets: ["Utils"]),
        .executable(
            name: "Day01",
            targets: ["Day01"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Utils",
            dependencies: []),
        .target(
            name: "Day01",
            dependencies: [ "Utils" ])
    ]
)
