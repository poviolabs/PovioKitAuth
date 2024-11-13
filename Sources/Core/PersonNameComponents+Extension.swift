//
//  PersonNameComponents+Extension.swift
//  PovioKitAuth
//
//  Created by Egzon Arifi on 09/11/2024.
//

import AuthenticationServices
import Foundation

public extension PersonNameComponents {
  var name: String? {
    guard let givenName = givenName else {
      return familyName
    }
    guard let familyName = familyName else {
      return givenName
    }
    return "\(givenName) \(familyName)"
  }
}

public extension PersonNameComponents {
  static func create(
    namePrefix: String? = .none,
    middleName: String? = .none,
    givenName: String? = .none,
    familyName: String? = .none,
    nameSuffix: String? = .none,
    nickname: String? = .none,
    phoneticRepresentation: PersonNameComponents? = .none
  ) -> PersonNameComponents {
    var components = PersonNameComponents()
    components.namePrefix = namePrefix
    components.familyName = familyName
    components.middleName = middleName
    components.givenName = givenName
    components.nameSuffix = nameSuffix
    components.nickname = nickname
    components.phoneticRepresentation = phoneticRepresentation
    return components
  }
}
