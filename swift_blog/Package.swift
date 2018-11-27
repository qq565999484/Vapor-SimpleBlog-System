// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "swift_blog",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/console.git", from: "3.0.0"),
        // 🍃 An expressive, performant, and extensible templating language built for Swift.
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0"),
        .package(url: "https://github.com/vapor/crypto.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/MihaelIsaev/FluentQuery.git", from: "0.4.30"),
        .package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.0-rc.2"),
        .package(url: "https://github.com/vapor/multipart.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/redis.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor-community/vapor-ext.git", from: "0.1.0")
    ],
    targets: [
        .target(name: "App", dependencies: ["VaporExt",
                                            "Multipart",
                                            "Redis",
                                            "FluentQuery",
                                            "FluentMySQL",
                                            "Crypto",
                                            "Random",
                                            "Leaf",
                                            "Authentication",
                                            "Console",
                                            "Command",
                                            "Async",
                                            "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

