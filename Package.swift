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
    .library(name: "PovioKitAuthFacebook", targets: ["PovioKitAuthFacebook"]),
    .library(name: "PovioKitAuthLinkedIn", targets: ["PovioKitAuthLinkedIn"])
  ],
  dependencies: [
    .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", .upToNextMajor(from: "4.0.0")),
    .package(url: "https://github.com/google/GoogleSignIn-iOS", .upToNextMajor(from: "8.0.0")),
    .package(url: "https://github.com/facebook/facebook-ios-sdk", .upToNextMajor(from: "17.0.0")),
  ],
  targets: [
    .target(
      name: "PovioKitAuthCore",
      dependencies: [
        .product(name: "KeychainAccess", package: "KeychainAccess"),
      ],
      path: "Sources/Core",
      resources: [.copy("../../Resources/PrivacyInfo.xcprivacy")]
    ),
    .target(
      name: "PovioKitAuthApple",
      dependencies: [
        "PovioKitAuthCore"
      ],
      path: "Sources/Apple",
      resources: [.copy("../../Resources/PrivacyInfo.xcprivacy")]
    ),
    .target(
      name: "PovioKitAuthGoogle",
      dependencies: [
        "PovioKitAuthCore",
        .product(name: "GoogleSignInSwift", package: "GoogleSignIn-iOS")
      ],
      path: "Sources/Google",
      resources: [.copy("../../Resources/PrivacyInfo.xcprivacy")]
    ),
    .target(
      name: "PovioKitAuthFacebook",
      dependencies: [
        "PovioKitAuthCore",
        .product(name: "FacebookLogin", package: "facebook-ios-sdk")
      ],
      path: "Sources/Facebook",
      resources: [.copy("../../Resources/PrivacyInfo.xcprivacy")]
    ),
    .target(
      name: "PovioKitAuthLinkedIn",
      dependencies: [
        "PovioKitAuthCore"
      ],
      path: "Sources/LinkedIn",
      resources: [.copy("../../Resources/PrivacyInfo.xcprivacy")]
    ),
    .testTarget(
      name: "Tests",
      dependencies: [
        "PovioKitAuthCore"
      ]
    ),
  ]
)
