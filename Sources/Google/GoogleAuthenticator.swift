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
import PovioKitPromise

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
  /// Will return promise with the `Response` object on success or with `Error` on error.
  public func signIn(from presentingViewController: UIViewController,
                     hint: String? = .none,
                     additionalScopes: [String]? = .none) -> Promise<Response> {
    guard !provider.hasPreviousSignIn() else {
      // restore user
      return Promise { seal in
        provider.restorePreviousSignIn { result, error in
          switch (result, error) {
          case (let user?, _):
            seal.resolve(with: user.authResponse)
          case (_, let actualError?):
            seal.reject(with: Error.system(actualError))
          case (.none, .none):
            seal.reject(with: Error.unhandledAuthorization)
          }
        }
      }
    }
    
    // sign in
    return Promise { seal in
      provider
        .signIn(withPresenting: presentingViewController, hint: hint, additionalScopes: additionalScopes) { result, error in
          switch (result, error) {
          case (let signInResult?, _):
            seal.resolve(with: signInResult.user.authResponse)
          case (_, let actualError?):
            let errorCode = (actualError as NSError).code
            if errorCode == GIDSignInError.Code.canceled.rawValue {
              seal.reject(with: Error.cancelled)
            } else {
              seal.reject(with: Error.system(actualError))
            }
          case (.none, .none):
            seal.reject(with: Error.unhandledAuthorization)
          }
        }
    }
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
