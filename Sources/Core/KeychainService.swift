//
//  KeychainService.swift
//  PovioKitAuth
//
//  Created by Borut Tomazin on 21/01/2025.
//  Copyright © 2025 Povio Inc. All rights reserved.
//

import Foundation
import KeychainAccess

/// A helper class for managing keychain operations
public final class KeychainService {
  public typealias Key = String
  private let keychain: Keychain
  
  /// Initializes a new instance of `KeychainService`.
  ///
  /// - Parameters:
  ///   - name: The service name used for identifying stored keychain items. Defaults to "KeychainService.main".
  ///   - accessGroup: An optional access group identifier for shared keychain access.
  public init(name: String = "KeychainService.main", accessGroup: String? = nil) {
    if let accessGroup {
      keychain = .init(service: name, accessGroup: accessGroup)
    } else {
      keychain = .init(service: name)
    }
  }
}

// MARK: - Public Methods
public extension KeychainService {
  /// Saves a string value to the keychain
  /// - Parameters:
  ///   - value: String value to save
  ///   - key: Key identifier for the value
  func save(_ value: String?, for key: Key) {
    keychain[key] = value
  }
  
  /// Reads a string value from the keychain
  /// - Parameters:
  ///   - key: Key identifier for the value
  /// - Returns: Optional string value stored in keychain
  func read(for key: Key) -> String? {
    keychain[key]
  }
  
  /// Saves a Codable item to the keychain
  /// - Parameters:
  ///   - item: Codable item to save
  ///   - key: Key identifier for the value
  /// - Throws: Encoding or keychain storage errors
  func save<T>(_ item: T, for key: Key) throws where T: Codable {
    let data = try JSONEncoder().encode(item)
    try keychain.set(data, key: key)
  }
  
  /// Reads a Codable item from the keychain
  /// - Parameters:
  ///   - type: Type of the item to decode
  ///   - key: Key identifier for the value
  /// - Returns: Optional decoded item
  func read<T>(_ item: T.Type, for key: Key) -> T? where T: Codable {
    do {
      guard let data = try keychain.getData(key) else { return nil }
      let item = try JSONDecoder().decode(item, from: data)
      return item
    } catch {
      return nil
    }
  }
  
  /// Removes all keychain items.
  /// - Throws: Keychain removal errors
  func clear() throws {
    try keychain.removeAll()
  }
}
