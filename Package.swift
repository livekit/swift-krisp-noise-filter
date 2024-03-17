// swift-tools-version:5.7
// (Xcode14.0+)

import PackageDescription

let package = Package(
    name: "LiveKitKrispNoiseFilter",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "LiveKitKrispNoiseFilter",
            targets: ["LiveKitKrispNoiseFilter"]
        ),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "KrispNoiseFilter",
            url: "https://storage.unxpected.co.jp/public/KrispNoiseFilter.xcframework.zip?",
            checksum: "ef184c7ce19a559a339bf6030bbd707c2b4dd5897a1484f1192b6504a1e9b727"
        ),
        .target(
            name: "LiveKitKrispNoiseFilter",
            dependencies: [
                "KrispNoiseFilter",
            ],
            resources: [
                .copy("Resources/c5.n.s.20949d.kw"),
                .copy("Resources/c5.s.w.c9ac8f.kw"),
                .copy("Resources/c6.f.s.ced125.kw"),
                .copy("Resources/VAD_model.kw"),
            ]
        ),
    ]
)
