// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Server",
    dependencies: [
        .package(url: "https://github.com/vapor/engine.git", from: "2.2.1"),
	.package(url: "https://github.com/vapor/sockets.git", from: "2.2.1"),
    ],
    targets: [
        .target(
            name: "Server",
            dependencies: ["Transport", "HTTP"]),
    ]
)

