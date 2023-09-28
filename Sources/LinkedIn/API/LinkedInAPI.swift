//
//  LinkedInAPI.swift
//  PovioKitAuth
//
//  Created by Borut Tomazin on 04/09/2023.
//  Copyright © 2023 Povio Inc. All rights reserved.
//

import Foundation
import PovioKitNetworking

public final class LinkedInAPI {
  private let client: AlamofireNetworkClient
  
  public init(client: AlamofireNetworkClient = .init()) {
    self.client = client
  }
}

public extension LinkedInAPI {
  func login(with request: LinkedInAuthRequest) async throws -> LinkedInAuthResponse {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .custom { decoder in
      let container = try decoder.singleValueContainer()
      let secondsRemaining = try container.decode(Int.self)
      return Date().addingTimeInterval(TimeInterval(secondsRemaining))
    }
    
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    
    return try await client
      .request(
        method: .post,
        endpoint: Endpoints.accessToken,
        encode: request,
        parameterEncoder: .urlEncoder(encoder: encoder)
      )
      .validate()
      .decode(LinkedInAuthResponse.self, decoder: decoder)
      .asAsync
  }
  
  func loadProfile(with request: LinkedInProfileRequest) async throws -> LinkedInProfileResponse {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601
    
    return try await client
      .request(
        method: .get,
        endpoint: Endpoints.profile,
        headers: ["Authorization": "Bearer \(request.token)"]
      )
      .validate()
      .decode(LinkedInProfileResponse.self, decoder: decoder)
      .asAsync
  }
  
  func loadEmail(with request: LinkedInProfileRequest) async throws -> LinkedInEmailValueResponse {
    return try await client
      .request(
        method: .get,
        endpoint: Endpoints.email,
        headers: ["Authorization": "Bearer \(request.token)"])
      .validate()
      .decode(LinkedInEmailResponse.self)
      .compactMap { $0.elements.first?.handle }
      .asAsync
  }
}

// MARK: - Error
public extension LinkedInAPI {
  enum Error: Swift.Error {
    case missingParameters
  }
}
