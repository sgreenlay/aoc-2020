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
            targets: ["Day01"]),
        .executable(
            name: "Day02",
            targets: ["Day02"]),
        .executable(
            name: "Day03",
            targets: ["Day03"]),
        .executable(
            name: "Day04",
            targets: ["Day04"]),
        .executable(
            name: "Day05",
            targets: ["Day05"]),
        .executable(
            name: "Day06",
            targets: ["Day06"]),
        .executable(
            name: "Day07",
            targets: ["Day07"]),
        .executable(
            name: "Day08",
            targets: ["Day08"]),
        .executable(
            name: "Day09",
            targets: ["Day09"]),
        .executable(
            name: "Day10",
            targets: ["Day10"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Utils",
            dependencies: []),
        .target(
            name: "Day01",
            dependencies: [ "Utils" ]),
        .target(
            name: "Day02",
            dependencies: [ "Utils" ]),
        .target(
            name: "Day03",
            dependencies: [ "Utils" ]),
        .target(
            name: "Day04",
            dependencies: [ "Utils" ]),
        .target(
            name: "Day05",
            dependencies: [ "Utils" ]),
        .target(
            name: "Day06",
            dependencies: [ "Utils" ]),
        .target(
            name: "Day07",
            dependencies: [ "Utils" ]),
        .target(
            name: "Day08",
            dependencies: [ "Utils" ]),
        .target(
            name: "Day09",
            dependencies: [ "Utils" ]),
        .target(
            name: "Day10",
            dependencies: [ "Utils" ])
    ]
)
