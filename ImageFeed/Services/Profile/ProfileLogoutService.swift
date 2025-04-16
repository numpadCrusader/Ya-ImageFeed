//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Nikita Khon on 15.04.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    
    // MARK: - Public Properties
    
    static let shared = ProfileLogoutService()
    
    // MARK: - private Properties
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let imagesListService = ImagesListService.shared
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Public Methods
    
    func logout() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        cleanCookies()
        imagesListService.cleanUpService()
        profileService.cleanUpService()
        profileImageService.cleanUpService()
        oAuth2TokenStorage.cleanUpStorage()
        
        window.rootViewController = SplashViewController()
    }
    
    // MARK: - Private Methods
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
