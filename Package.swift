// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HttpRouter",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(name: "HttpRouter", targets: ["HttpRouter"]),
        .library(name: "HttpTestApi", targets: ["HttpTestApi"]),
        .executable(name: "RouterBenchmark", targets: ["RouterBenchmark"]),
    ],
    dependencies: [
        //.package(url: "https://github.com/apple/swift-nio.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "HttpRouter", dependencies: []),
        .target(name: "HttpTestApi", dependencies: ["HttpRouter"]),
        .target(name: "RouterBenchmark", dependencies: ["HttpRouter"]),
        .testTarget(name: "HttpRouterTests", dependencies: ["HttpRouter", "HttpTestApi"]),
    ]
)
