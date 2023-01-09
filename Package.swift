// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "SwiftWasmQuoridor",
    platforms: [.macOS(.v12), .iOS(.v13)],
    products: [
        .executable(name: "WasmLib", targets: ["WasmLib"]),
    ],
    dependencies: [
        .package(url: "https://github.com/sidepelican/QuoridorEngine.git", from: "1.0.0"),
//        .package(url: "https://github.com/sidepelican/WasmCallableKit.git", from: "0.1.0"),
        .package(path: "../WasmCallableKit"),
        // .package(path: "../WasmCallableKit/Codegen"),
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
        // .plugin(
        //     name: "CodegenPlugin",
        //     capability: .command(
        //         intent: .custom(verb: "codegen", description: "Generate codes"),
        //         permissions: [.writeToPackageDirectory(reason: "Place generated code")]
        //     ),
        //     dependencies: [
        //         .product(name: "codegen", package: "Codegen"),
        //     ]
        // ),
    ]
)
