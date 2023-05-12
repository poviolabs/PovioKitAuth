// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PovioKitAuth",
  platforms: [
    .iOS(.v13)
  ],
  products: [
    .library(name: "PovioKitAuthCore", targets: ["PovioKitAuthCore"]),
    .library(name: "PovioKitAuthApple", targets: ["PovioKitAuthApple"]),
    .library(name: "PovioKitAuthGoogle", targets: ["PovioKitAuthGoogle"]),
    .library(name: "PovioKitAuthFacebook", targets: ["PovioKitAuthFacebook"])
  ],
  dependencies: [
    .package(url: "https://github.com/poviolabs/PovioKit", .upToNextMajor(from: "3.0.0")),
    .package(url: "https://github.com/google/GoogleSignIn-iOS", .upToNextMajor(from: "7.0.0")),
    .package(url: "https://github.com/facebook/facebook-ios-sdk", .upToNextMajor(from: "15.0.0")),
  ],
  targets: [
    .target(
      name: "PovioKitAuthCore",
      dependencies: [
        .product(name: "PovioKitPromise", package: "PovioKit"),
      ],
      path: "Sources/Core"
    ),
    .target(
      name: "PovioKitAuthApple",
      dependencies: [
        "PovioKitAuthCore"
      ],
      path: "Sources/Apple"
    ),
    .target(
      name: "PovioKitAuthGoogle",
      dependencies: [
        "PovioKitAuthCore",
        .product(name: "GoogleSignInSwift", package: "GoogleSignIn-iOS")
      ],
      path: "Sources/Google"
    ),
    .target(
      name: "PovioKitAuthFacebook",
      dependencies: [
        "PovioKitAuthCore",
        .product(name: "PovioKitCore", package: "PovioKit"),
        .product(name: "FacebookLogin", package: "facebook-ios-sdk")
      ],
      path: "Sources/Facebook"
    ),
    .testTarget(
      name: "Tests",
      dependencies: [
        "PovioKitAuthCore"
      ]
    ),
  ]
)
