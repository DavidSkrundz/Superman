// swift-tools-version: 6.0

import PackageDescription
import CompilerPluginSupport

let package = Package(
	name: "Superman",
	platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
	products: [
		.library(
			name: "Superman",
			targets: ["Superman"]
		),
		.executable(
			name: "SupermanSample",
			targets: ["SupermanSample"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-syntax.git", from: "600.0.0"),
	],
	targets: [
		.macro(
			name: "SupermanMacros",
			dependencies: [
				.product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
				.product(name: "SwiftCompilerPlugin", package: "swift-syntax")
			]
		),
		.target(name: "Superman", dependencies: ["SupermanMacros"]),
		.executableTarget(name: "SupermanSample", dependencies: ["Superman"]),
		.testTarget(
			name: "SupermanTests",
			dependencies: [
				"SupermanMacros",
				.product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
			]
		),
	]
)
