// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Navalnyarchive",
    platforms: [
        .macOS(.v12), .iOS(.v15)
    ],
    products: [
        .library(name: "Navalnyarchive", targets: ["Navalnyarchive"]),
    ],
    targets: [
        .target(
            name: "Navalnyarchive",
            path: "src"
        ),
    ]
)
