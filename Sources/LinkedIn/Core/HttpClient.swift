//
//  HttpClient.swift
//  PovioKitAuth
//
//  Created by Borut Tomazin on 22/05/2024.
//  Copyright © 2024 Povio Inc. All rights reserved.
//

import Foundation

struct HttpClient {
  func request<D: Decodable>(
    method: String,
    url: URL,
    headers: [String: String]?,
    decodeTo decode: D.Type,
    with decoder: JSONDecoder = .init()
  ) async throws -> D {
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method
    urlRequest.allHTTPHeaderFields = headers
    
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    if let httpResponse = response as? HTTPURLResponse,
       !(200...299).contains(httpResponse.statusCode) {
      throw NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)
    }
    
    return try decoder.decode(decode, from: data)
  }
}
