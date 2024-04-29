//
//  AppleAuthenticator+Models.swift
//  PovioKitAuth
//
//  Created by Borut Tomazin on 28/10/2022.
//  Copyright © 2023 Povio Inc. All rights reserved.
//

import AuthenticationServices
import Foundation

public extension AppleAuthenticator {
  enum Nonce {
    case random(length: UInt)
    case custom(value: String)
  }
  
  struct Response {
    public let userId: String
    public let token: String
    public let authCode: String
    public let nameComponents: PersonNameComponents?
    public let email: Email
    public let expiresAt: Date

    public var name: String {
      [nameComponents?.givenName, nameComponents?.familyName]
        .compactMap { $0 }
        .joined(separator: " ")
    }
  }
  
  enum Error: Swift.Error {
    case system(_ error: Swift.Error)
    case cancelled
    case invalidNonceLength
    case invalidIdentityToken
    case unhandledAuthorization
    case credentialsRevoked
    case missingExpiration
    case missingEmail
  }
}

public extension AppleAuthenticator.Response {
  struct Email {
    public let address: String
    public let isPrivate: Bool
    public let isVerified: Bool
  }
}
