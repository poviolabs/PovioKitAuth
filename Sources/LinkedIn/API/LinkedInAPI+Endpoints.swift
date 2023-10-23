//
//  LinkedInAPI+Endpoints.swift
//  PovioKitAuth
//
//  Created by Borut Tomazin on 04/09/2023.
//  Copyright © 2023 Povio Inc. All rights reserved.
//

import Foundation
import PovioKitNetworking

extension LinkedInAPI {
  enum Endpoints: EndpointEncodable {
    case accessToken
    case profile
    case email
    
    var path: Path {
      switch self {
      case .accessToken:
        return "accessToken"
      case .profile:
        return "me"
      case .email:
        return "emailAddress?q=members&projection=(elements*(handle~))"
      }
    }
    
    var url: String {
      switch self {
      case .accessToken:
        return "https://www.linkedin.com/oauth/v2/\(path)"
      case .profile, .email:
        return "https://api.linkedin.com/v2/\(path)"
      }
    }
  }
}
