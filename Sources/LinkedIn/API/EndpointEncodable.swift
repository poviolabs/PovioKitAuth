//
//  EndpointEncodable.swift
//  PovioKitAuth
//
//  Created by Borut Tomazin on 04/09/2023.
//  Copyright © 2024 Povio Inc. All rights reserved.
//

import Foundation
import PovioKitNetworking

protocol EndpointEncodable: URLConvertible {
  typealias Path = String
  
  var path: Path { get }
  var url: String { get }
}

extension EndpointEncodable {
  func asURL() throws -> URL {
    .init(stringLiteral: url)
  }
}
