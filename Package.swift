// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppConfig",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppConfig",
            targets: ["AppConfig"]
		),
    ],
	dependencies: [
		.package(url: "https://github.com/Flight-School/AnyCodable", from: "0.6.0")
	],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AppConfig",
			dependencies: [
				.product(name: "AnyCodable", package: "AnyCodable")
			]
		),
		.executableTarget(
			name: "TestApp",
			dependencies: [
				.target(name: "AppConfig")
			]
		),
        .testTarget(
            name: "AppConfigTests",
            dependencies: ["AppConfig"]),
    ]
)
