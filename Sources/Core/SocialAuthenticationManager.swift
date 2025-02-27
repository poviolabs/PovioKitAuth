//
//  SocialAuthenticationManager.swift
//  PovioKitAuth
//
//  Created by Borut Tomazin on 30/01/2023.
//  Copyright © 2025 Povio Inc. All rights reserved.
//

import Foundation
import UIKit

public final class SocialAuthenticationManager {
  private let authenticators: [Authenticator]
  
  public init(authenticators: [Authenticator]) {
    self.authenticators = authenticators
  }
}

extension SocialAuthenticationManager: Authenticator {
  public var isAuthenticated: Authenticator.Authenticated {
    authenticators.contains { $0.isAuthenticated }
  }
  
  public var currentAuthenticator: Authenticator? {
    authenticators.first { $0.isAuthenticated }
  }
  
  public func authenticator<A: Authenticator>(for type: A.Type) -> A? {
    authenticators.first { $0 is A } as? A
  }
  
  public func signOut() {
    authenticators.forEach { $0.signOut() }
  }
  
  public func canOpenUrl(_ url: URL, application: UIApplication, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
    authenticators.contains { $0.canOpenUrl(url, application: application, options: options) }
  }
}
