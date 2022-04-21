// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AnnotatedTree",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AnnotatedTree",
            targets: ["AnnotatedTree"]),
    ],
    dependencies: [
        .package(name: "AnnotatedSentence", url: "https://github.com/StarlangSoftware/AnnotatedSentence-Swift.git", .exact("1.0.6")),
        .package(name: "ParseTree", url: "https://github.com/StarlangSoftware/ParseTree-Swift.git", .exact("1.0.4")),
        .package(name: "Util", url: "https://github.com/StarlangSoftware/Util-Swift.git", .exact("1.0.8")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AnnotatedTree",
            dependencies: ["AnnotatedSentence", "ParseTree", "Util"]),
        .testTarget(
            name: "AnnotatedTreeTests",
            dependencies: ["AnnotatedTree"]),
    ]
)
