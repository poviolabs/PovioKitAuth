//
//  GoogleAuthenticator+Models.swift
//  PovioKitAuth
//
//  Created by Borut Tomazin on 30/01/2023.
//  Copyright © 2025 Povio Inc. All rights reserved.
//

import Foundation
import PovioKitAuthCore

public extension GoogleAuthenticator {
  struct Response {
    public let userId: String?
    public let idToken: String?
    public let accessToken: String
    public let refreshToken: String
    public let nameComponents: PersonNameComponents?
    public let email: String?
    public let expiresAt: Date?
    
    /// User full name represented by `givenName` and `familyName`
    public var name: String? {
      nameComponents?.name
    }
  }
}
