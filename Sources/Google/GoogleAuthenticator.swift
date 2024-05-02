//
//  GoogleAuthenticator.swift
//  PovioKitAuth
//
//  Created by Borut Tomazin on 25/10/2022.
//  Copyright © 2024 Povio Inc. All rights reserved.
//

import Foundation
import GoogleSignIn
import PovioKitAuthCore

public final class GoogleAuthenticator {
  private let provider: GIDSignIn
  
  public init() {
    self.provider = GIDSignIn.sharedInstance
  }
}

// MARK: - Public Methods
extension GoogleAuthenticator: Authenticator {
  /// SignIn user.
  ///
  /// Will asynchronously return the `Response` object on success or with `Error` on error.
  public func signIn(from presentingViewController: UIViewController,
                     hint: String? = .none,
                     additionalScopes: [String]? = .none) async throws -> Response {
    guard !provider.hasPreviousSignIn() else {
      return try await restorePreviousSignIn()
    }
    
    return try await signInUser(from: presentingViewController, hint: hint, additionalScopes: additionalScopes)
  }
  
  /// Clears the signIn footprint and logs out the user immediatelly.
  public func signOut() {
    provider.signOut()
  }
  
  /// Returns the current authentication state.
  public var isAuthenticated: Authenticated {
    provider.hasPreviousSignIn()
  }
  
  /// Boolean if given `url` should be handled.
  ///
  /// Call this from UIApplicationDelegate’s `application:openURL:options:` method.
  public func canOpenUrl(_ url: URL, application: UIApplication, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    GIDSignIn.sharedInstance.handle(url)
  }
}

// MARK: - Private Methods
private extension GoogleAuthenticator {
  func restorePreviousSignIn() async throws -> Response {
    try await withCheckedThrowingContinuation { continuation in
      provider.restorePreviousSignIn { user, error in
        if let user = user {
          continuation.resume(returning: user.authResponse)
        } else if let error = error {
          continuation.resume(throwing: Error.system(error))
        } else {
          continuation.resume(throwing: Error.unhandledAuthorization)
        }
      }
    }
  }

  func signInUser(from presentingViewController: UIViewController, hint: String?, additionalScopes: [String]?) async throws -> Response {
    try await withCheckedThrowingContinuation { continuation in
      provider
        .signIn(withPresenting: presentingViewController, hint: hint, additionalScopes: additionalScopes) { result, error in
          switch (result, error) {
          case (let signInResult?, _):
            continuation.resume(returning: signInResult.user.authResponse)
          case (_, let actualError?):
            let errorCode = (actualError as NSError).code
            if errorCode == GIDSignInError.Code.canceled.rawValue {
              continuation.resume(throwing: Error.cancelled)
            } else {
              continuation.resume(throwing: Error.system(actualError))
            }
          case (.none, .none):
            continuation.resume(throwing: Error.unhandledAuthorization)
          }
        }
    }
  }
}

// MARK: - Error
public extension GoogleAuthenticator {
  enum Error: Swift.Error {
    case system(_ error: Swift.Error)
    case cancelled
    case unhandledAuthorization
    case alreadySignedIn
  }
}

// MARK: - Private Extension
private extension GIDGoogleUser {
  var authResponse: GoogleAuthenticator.Response {
    .init(
      userId: userID,
      idToken: idToken?.tokenString,
      accessToken: accessToken.tokenString,
      refreshToken: refreshToken.tokenString,
      name: profile?.name,
      email: profile?.email,
      expiresAt: accessToken.expirationDate
    )
  }
}
