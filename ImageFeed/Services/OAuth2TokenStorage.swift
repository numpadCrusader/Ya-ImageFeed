//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Nikita Khon on 08.04.2025.
//

import Foundation

protocol OAuth2TokenStorageProtocol {
    var token: String? { get }
    
    func storeAccessToken(_ newToken: String)
}

final class OAuth2TokenStorage {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case accessToken
    }
}

// MARK: - OAuth2TokenStorageProtocol

extension OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    
    var token: String? {
        get {
            storage.string(forKey: Keys.accessToken.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.accessToken.rawValue)
        }
    }
    
    func storeAccessToken(_ newToken: String) {
        token = newToken
    }
}
