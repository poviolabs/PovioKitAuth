//
//  GoogleAuthenticator+Models.swift
//  PovioKitAuth
//
//  Created by Borut Tomazin on 30/01/2023.
//  Copyright © 2023 Povio Inc. All rights reserved.
//

import Foundation

public extension LinkedInAuthenticator {
  struct Configuration {
    let clientId: String
    let clientSecret: String
    let permissions: String
    let redirectUrl: URL
    let authEndpoint: URL = "https://www.linkedin.com/oauth/v2/authorization"
    let authCancel: URL = "https://www.linkedin.com/oauth/v2/login-cancel"
    
    public init(clientId: String, clientSecret: String, permissions: String, redirectUrl: URL) {
      self.clientId = clientId
      self.clientSecret = clientSecret
      self.permissions = permissions
      self.redirectUrl = redirectUrl
    }
    
    func authorizationUrl(state: String) -> URL? {
      guard var urlComponents = URLComponents(url: authEndpoint, resolvingAgainstBaseURL: false) else { return nil }
      urlComponents.queryItems = [
        .init(name: "response_type", value: "code"),
        .init(name: "client_id", value: clientId),
        .init(name: "redirect_uri", value: redirectUrl.absoluteString),
        .init(name: "state", value: state),
        .init(name: "scope", value: permissions)
      ]
      return urlComponents.url
    }
  }
  
  struct Response {
    public let userId: String
    public let token: String
    public let name: String
    public let email: String
    public let expiresAt: Date
  }
}
