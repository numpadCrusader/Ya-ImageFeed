//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Nikita Khon on 08.04.2025.
//

import Foundation
import SwiftKeychainWrapper

protocol OAuth2TokenStorageProtocol {
    var token: String? { get }
    var isTokenFresh: Bool { get }
    
    func storeAccessToken(_ newToken: String)
}

final class OAuth2TokenStorage {
    
    // MARK: - Public Properties
    
    static let shared = OAuth2TokenStorage()
    
    // MARK: - Private Properties
    
    private let userDefaults: UserDefaults = .standard
    private let keyChain: KeychainWrapper = .standard
    
    private enum Keys: String {
        case accessToken
        case isTokenFresh
    }
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Public Methods
    
    func cleanUpStorage() {
        keyChain.removeObject(forKey: Keys.accessToken.rawValue)
        userDefaults.setValue(false, forKey: Keys.isTokenFresh.rawValue)
    }
}

// MARK: - OAuth2TokenStorageProtocol

extension OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    
    var token: String? {
        keyChain.string(forKey: Keys.accessToken.rawValue)
    }
    
    var isTokenFresh: Bool {
        userDefaults.bool(forKey: Keys.isTokenFresh.rawValue)
    }
    
    func storeAccessToken(_ newToken: String) {
        keyChain.set(newToken, forKey: Keys.accessToken.rawValue)
        userDefaults.setValue(true, forKey: Keys.isTokenFresh.rawValue)
    }
}
