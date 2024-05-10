//
//  FacebookAuthenticator+Models.swift
//  PovioKitAuth
//
//  Created by Borut Tomazin on 30/11/2022.
//  Copyright © 2024 Povio Inc. All rights reserved.
//

import Foundation

public extension FacebookAuthenticator {
  struct Response {
    public let userId: String
    public let token: String
    public let name: String?
    public let email: String?
    public let expiresAt: Date
  }
  
  struct GraphResponse: Decodable {
    let id: String
    let email: String?
    let firstName: String?
    let lastName: String?
    let picture: PictureData?

    struct PictureData: Decodable {
      let data: PictureURL
    }

    struct PictureURL: Decodable {
      let isSilhouette: Bool
      let width: Int
      let url: String
      let height: Int
    }
  }
}

public extension FacebookAuthenticator.GraphResponse {
  var displayName: String {
    [firstName, lastName]
      .compactMap { $0 }
      .joined(separator: " ")
  }
}
