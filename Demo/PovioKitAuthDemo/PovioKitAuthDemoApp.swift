//
//  PovioKitAuthDemoApp.swift
//  PovioKitAuthDemo
//
//  Created by Borut Tomazin on 10/05/2024.
//

import SwiftUI

@main
struct PovioKitAuthDemoApp: App {
  var body: some Scene {
    WindowGroup {
      SignInView(viewModel: .init())
    }
  }
}
