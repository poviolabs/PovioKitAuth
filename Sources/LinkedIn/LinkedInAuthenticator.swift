//
//  LinkedInAuthenticator.swift
//  PovioKitAuth
//
//  Created by Borut Tomazin on 04/09/2023.
//  Copyright © 2023 Povio Inc. All rights reserved.
//

import Foundation
import PovioKitAuthCore
import PovioKitPromise
import SwiftUI

@available(iOS 15.0, *)
public final class LinkedInAuthenticator {
  @State private var openWebView = false
  private let linkedInAPI: LinkedInAPI
  
  public init(linkedInAPI: LinkedInAPI = .init()) {
    self.linkedInAPI = linkedInAPI
  }
}

// MARK: - Public Methods
@available(iOS 15.0, *)
extension LinkedInAuthenticator: Authenticator {
  /// SignIn user.
  ///
  /// Will return promise with the `Response` object on success or with `Error` on error.
  public func signIn(from view: any View,
                     with configuration: Configuration,
                     additionalScopes: [String]? = .none) -> Promise<Response> {
    Promise { seal in
      _ = view.sheet(isPresented: $openWebView) {
        LinkedInWebView(with: configuration) { data in
          Task {
            do {
              let response = try await self.loadData(code: data.code, with: configuration)
              seal.resolve(with: response)
            } catch {
              seal.reject(with: error)
            }
          }
        } onFailure: {
          seal.reject(with: Error.unhandledAuthorization)
        }
      }
    }
  }
  
  /// Clears the signIn footprint and logs out the user immediatelly.
  public func signOut() {
    // TODO
  }
  
  /// Returns the current authentication state.
  public var isAuthenticated: Authenticated {
    false // TODO
  }
  
  /// Boolean if given `url` should be handled.
  ///
  /// Call this from UIApplicationDelegate’s `application:openURL:options:` method.
  public func canOpenUrl(_ url: URL, application: UIApplication, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    true // TODO
  }
}

// MARK: - Error
@available(iOS 15.0, *)
public extension LinkedInAuthenticator {
  enum Error: Swift.Error {
//    case system(_ error: Swift.Error)
//    case cancelled
    case unhandledAuthorization
//    case alreadySignedIn
  }
}

// MARK: - Private Extension
@available(iOS 15.0, *)
private extension LinkedInAuthenticator {
  func loadData(code: String, with configuration: Configuration) async throws -> Response {
    let authRequest: LinkedInAPI.LinkedInAuthRequest = .init(
      code: code,
      redirectUri: configuration.redirectUrl.absoluteString,
      clientId: configuration.clientId,
      clientSecret: configuration.clientSecret
    )
    let authResponse = try await linkedInAPI.login(with: authRequest)
    let profileResponse = try await linkedInAPI.loadProfile(with: .init(token: authResponse.accessToken))
    let emailResponse = try await linkedInAPI.loadEmail(with: .init(token: authResponse.accessToken))
    
    let name = [profileResponse.localizedFirstName, profileResponse.localizedLastName].joined(separator: " ")
    return Response(
      userId: profileResponse.id,
      token: authResponse.accessToken,
      name: name,
      email: emailResponse.emailAddress,
      expiresAt: authResponse.expiresIn
    )
  }
}
