//
//  LinkedInAPI.swift
//  PovioKitAuth
//
//  Created by Borut Tomazin on 04/09/2023.
//  Copyright © 2024 Povio Inc. All rights reserved.
//

import Foundation

public final class LinkedInAPI {
  private let client: HttpClient = .init()
  
  public init() {}
}

public extension LinkedInAPI {
  func login(with request: LinkedInAuthRequest) async throws -> LinkedInAuthResponse {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    let jsonData = try encoder.encode(request)
    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
    guard let jsonDict = jsonObject as? [String: Any] else {
      throw Error.invalidRequest
    }
    
    guard var components = URLComponents(string: Endpoints.accessToken.url) else {
      throw Error.invalidUrl
    }
    
    let queryItems: [URLQueryItem] = jsonDict.compactMap { key, value in
      (value as? String).map { .init(name: key, value: $0) }
    }
    
    components.queryItems = queryItems
    guard let url = components.url else {
      throw Error.invalidUrl
    }
    
    let response = try await client.request(
      method: "POST",
      url: url,
      headers: [.init(name: "Content-Type", value: "application/x-www-form-urlencoded")]
    )
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .custom { decoder in
      let container = try decoder.singleValueContainer()
      let secondsRemaining = try container.decode(Int.self)
      return Date().addingTimeInterval(TimeInterval(secondsRemaining))
    }
    let decoded = try decoder.decode(LinkedInAuthResponse.self, from: response)
    
    return decoded
  }
  
  func loadProfile(with request: LinkedInProfileRequest) async throws -> LinkedInProfileResponse {
    guard let url = URL(string: Endpoints.profile.url) else { throw Error.invalidUrl }
    
    let response = try await client.request(
      method: "GET",
      url: url,
      headers: [.init(name: "Authorization", value: "Bearer \(request.token)")]
    )
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601
    let decoded = try decoder.decode(LinkedInProfileResponse.self, from: response)
    
    return decoded
  }
  
  func loadEmail(with request: LinkedInProfileRequest) async throws -> LinkedInEmailValueResponse {
    guard let url = URL(string: Endpoints.email.url) else { throw Error.invalidUrl }
    
    let response = try await client.request(
      method: "GET",
      url: url,
      headers: [.init(name: "Authorization", value: "Bearer \(request.token)")]
    )
    
    let decoded = try JSONDecoder().decode(LinkedInEmailResponse.self, from: response)
    
    guard let emailObject = decoded.elements.first?.handle else {
      throw Error.invalidResponse
    }
    
    return emailObject
  }
}

// MARK: - Error
public extension LinkedInAPI {
  enum Error: Swift.Error {
    case missingParameters
    case invalidUrl
    case invalidRequest
    case invalidResponse
  }
}
