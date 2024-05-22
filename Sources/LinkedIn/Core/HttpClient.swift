//
//  HttpClient.swift
//  PovioKitAuth
//
//  Created by Borut Tomazin on 22/05/2024.
//  Copyright © 2024 Povio Inc. All rights reserved.
//

import Foundation

class HttpClient {
  func request(method: String, url: URL, headers: [Header]) async throws -> Data {
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method
    headers.forEach {
      urlRequest.setValue($0.value, forHTTPHeaderField: $0.name)
    }
    
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    if let httpResponse = response as? HTTPURLResponse,
       !(200...299).contains(httpResponse.statusCode) {
      throw NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)
    }
    
    return data
  }
}

extension HttpClient {
  struct Header {
    let name: String
    let value: String
  }
}
