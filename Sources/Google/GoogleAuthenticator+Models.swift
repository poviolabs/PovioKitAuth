//
//  GoogleAuthenticator+Models.swift
//  PovioKitAuth
//
//  Created by Borut Tomazin on 30/01/2023.
//  Copyright © 2023 Povio Inc. All rights reserved.
//

import Foundation

public extension GoogleAuthenticator {
  struct Response {
    public let userId: String?
    public let idToken: String?
    public let accessToken: String
    public let refreshToken: String
    public let name: String?
    public let email: String?
    public let expiresAt: Date?
  }
}
