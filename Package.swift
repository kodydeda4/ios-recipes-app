// swift-tools-version: 5.10

import PackageDescription

let package = Package(
  name: "ios-recipes-app",
  platforms: [.iOS(.v15)],
  products: [
    // Dependencies
    .library(name: "ApiClient"),
    .library(name: "Environment"),
    .library(name: "NavigationControllerClient"),

    // Features
    .library(name: "AppFeature"),
    .library(name: "MealCategoryCollectionFeature"),
    .library(name: "MealCollectionFeature"),
    .library(name: "MealDetailsFeature"),
    
    // Libraries
    .library(name: "SharedViews"),
    .library(name: "UIKitHelpers"),
  ],
  dependencies: [
    .package(url: "https://github.com/airbnb/epoxy-ios", from: "0.10.0"),
  ],
  targets: [
    // Dependencies
    .dependency("ApiClient"),
    .dependency("NavigationControllerClient"),
    .dependency("Environment", dependencies: [
      "ApiClient",
      "NavigationControllerClient",
    ]),

    //    // Features
    .feature("AppFeature", dependencies: [
      "MealCategoryCollectionFeature",
      "MealCollectionFeature",
      "MealDetailsFeature",
    ]),
    .feature("MealCategoryCollectionFeature", dependencies: [
      
    ]),
    .feature("MealCollectionFeature", dependencies: [
      
    ]),
    .feature("MealDetailsFeature", dependencies: [
      
    ]),

    // Libraries
      .library("SharedViews", dependencies: [
        .product(name: "Epoxy", package: "epoxy-ios"),
        .product(name: "EpoxyCore", package: "epoxy-ios"),
        .product(name: "EpoxyCollectionView", package: "epoxy-ios"),
        .product(name: "EpoxyBars", package: "epoxy-ios"),
        .product(name: "EpoxyNavigationController", package: "epoxy-ios"),
        .product(name: "EpoxyPresentations", package: "epoxy-ios"),
        .product(name: "EpoxyLayoutGroups", package: "epoxy-ios"),
      ]),
    .library("UIKitHelpers", dependencies: [
      .product(name: "Epoxy", package: "epoxy-ios"),
      .product(name: "EpoxyCore", package: "epoxy-ios"),
      .product(name: "EpoxyCollectionView", package: "epoxy-ios"),
      .product(name: "EpoxyBars", package: "epoxy-ios"),
      .product(name: "EpoxyNavigationController", package: "epoxy-ios"),
      .product(name: "EpoxyPresentations", package: "epoxy-ios"),
      .product(name: "EpoxyLayoutGroups", package: "epoxy-ios"),
    ])
  ]
)

// MARK: - Helpers

extension Product {
  
  /// Create a library with identical name & target.
  static func library(name: String) -> Product {
    .library(name: name, targets: [name])
  }
}

extension Target {
  
  /// Create a target with the default path & dependencies for a feature.
  static func feature(_ name: String, dependencies: [Target.Dependency] = []) -> Target {
    .target(
      name: name,
      dependencies: dependencies + [
        "Environment",
        "SharedViews",
        "UIKitHelpers",
        .product(name: "Epoxy", package: "epoxy-ios"),
        .product(name: "EpoxyCore", package: "epoxy-ios"),
        .product(name: "EpoxyCollectionView", package: "epoxy-ios"),
        .product(name: "EpoxyBars", package: "epoxy-ios"),
        .product(name: "EpoxyNavigationController", package: "epoxy-ios"),
        .product(name: "EpoxyPresentations", package: "epoxy-ios"),
        .product(name: "EpoxyLayoutGroups", package: "epoxy-ios"),
      ],
      path: "Sources/Features/\(name)"
    )
  }
  
  /// Create a target with the default path & dependencies for a dependency.
  static func dependency(_ name: String, dependencies: [Target.Dependency] = []) -> Target {
    .target(
      name: name,
      dependencies: dependencies + [
      ],
      path: "Sources/Dependencies/\(name)"
    )
  }
  
  /// Create a target with the default path & dependencies for a library.
  static func library(
    _ name: String,
    dependencies: [Target.Dependency] = [],
    resources: [Resource] = []
  ) -> Target {
    .target(
      name: name,
      dependencies: dependencies,
      path: "Sources/Library/\(name)",
      resources: resources
    )
  }
}

