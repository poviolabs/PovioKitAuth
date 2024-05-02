//
//  FacebookAuthenticator.swift
//  PovioKitAuth
//
//  Created by Borut Tomazin on 29/11/2022.
//  Copyright © 2024 Povio Inc. All rights reserved.
//

import Foundation
import FacebookLogin
import PovioKitCore
import PovioKitAuthCore

public final class FacebookAuthenticator {
  private let provider: LoginManager
  
  public init() {
    self.provider = .init()
  }
}

// MARK: - Public Methods
extension FacebookAuthenticator: Authenticator {
  /// SignIn user.
  ///
  /// The `permissions` to use when doing a sign in.
  /// Will asynchronously return the `Response` object on success or with `Error` on error.
  public func signIn(
    from presentingViewController: UIViewController,
    with permissions: [Permission] = [.email, .publicProfile]) async throws -> Response
  {
    let permissions: [String] = permissions.map { $0.name }
    let token = try await signIn(with: permissions, on: presentingViewController)
    return try await fetchUserDetails(with: token)
  }
  
  /// Clears the signIn footprint and logs out the user immediatelly.
  public func signOut() {
    provider.logOut()
  }
  
  /// Returns the current authentication state.
  public var isAuthenticated: Authenticated {
    guard let token = AccessToken.current else { return false }
    return !token.isExpired
  }
  
  /// Boolean if given `url` should be handled.
  ///
  /// Call this from UIApplicationDelegate’s `application:openURL:options:` method.
  public func canOpenUrl(_ url: URL, application: UIApplication, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    ApplicationDelegate.shared.application(application, open: url, options: options)
  }
}

// MARK: - Error
public extension FacebookAuthenticator {
  enum Error: Swift.Error {
    case system(_ error: Swift.Error)
    case cancelled
    case invalidIdentityToken
    case invalidUserData
    case missingUserData
    case userDataDecode
  }
}

// MARK: - Private Methods
private extension FacebookAuthenticator {
  func signIn(with permissions: [String], on presentingViewController: UIViewController) async throws -> AccessToken {
    try await withCheckedThrowingContinuation { continuation in
      provider.logIn(permissions: permissions, from: presentingViewController) { result, error in
        switch (result, error) {
        case (let result?, nil):
          if result.isCancelled {
            continuation.resume(throwing: Error.cancelled)
          } else if let token = result.token {
            continuation.resume(returning: token)
          } else {
            continuation.resume(throwing: Error.invalidIdentityToken)
          }
        case (nil, let error?):
          continuation.resume(throwing: Error.system(error))
        default:
          continuation.resume(throwing: Error.system(NSError(domain: "com.povio.facebook.error", code: -1, userInfo: nil)))
        }
      }
    }
  }

  func fetchUserDetails(with token: AccessToken) async throws -> Response {
    try await withCheckedThrowingContinuation { continuation in
      let request = GraphRequest(
        graphPath: "me",
        parameters: ["fields": "id, email, first_name, last_name"],
        tokenString: token.tokenString,
        httpMethod: nil,
        flags: .doNotInvalidateTokenOnError
      )

      request.start { _, result, error in
        switch result {
        case .some(let response):
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          
          do {
            let data = try JSONSerialization.data(withJSONObject: response, options: [])
            let object = try data.decode(GraphResponse.self, with: decoder)

            let authResponse = Response(
              userId: object.id,
              token: token.tokenString,
              name: object.displayName,
              email: object.email,
              expiresAt: token.expirationDate
            )
            continuation.resume(returning: authResponse)
          } catch {
            continuation.resume(throwing: Error.userDataDecode)
          }
        case .none:
          continuation.resume(throwing: Error.missingUserData)
        }
      }
    }
  }
}
