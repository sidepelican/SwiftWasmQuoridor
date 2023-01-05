// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "SwiftWasmQuoridor",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        .executable(name: "WasmLib", targets: ["WasmLib"]),
    ],
    dependencies: [
        .package(url: "https://github.com/sidepelican/QuoridorEngine.git", from: "1.0.0"),
        .package(url: "https://github.com/sidepelican/WasmCallableKit.git", from: "0.1.0"),
    ],
    targets: [
        .executableTarget(
            name: "WasmLib",
            dependencies: [
                "QuoridorEngine",
                "WasmCallableKit",
            ],
            linkerSettings: [
                .unsafeFlags([
                    "-Xclang-linker", "-mexec-model=reactor",
                    "-Xlinker", "--export=main",
                ])
            ]
        ),
    ]
)
