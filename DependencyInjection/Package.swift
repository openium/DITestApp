// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription

// swiftlint:disable:next prefixed_toplevel_constant
let package = Package(
    name: "DependencyInjection",
    platforms: [
        .macOS(.v10_15), .iOS(.v15)
    ],
    products: [
        .library(
            name: "DependencyInjection",
            targets: ["DependencyInjection"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax", from: "509.0.0")
    ],
    targets: [
        .target(
            name: "DependencyInjection",
            dependencies: ["DependencyInjectionMacroImpl"]
        ),
        .macro(
            name: "DependencyInjectionMacroImpl",
            dependencies: [
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftDiagnostics", package: "swift-syntax")
            ]
        ),
        // Tests
        .testTarget(
            name: "DependencyInjectionMacroTests",
            dependencies: [
                "DependencyInjectionMacroImpl",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
            ]
        )
    ]
)
