//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Nikita Khon on 16.04.2025.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}

final class AuthHelper: AuthHelperProtocol {
    
    // MARK: - Public Properties
    
    let configuration: AuthConfiguration

    // MARK: - Initializers
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    // MARK: - AuthHelperProtocol
    
    func authRequest() -> URLRequest? {
        guard let url = authURL() else { return nil }
        
        return URLRequest(url: url)
    }
    
    func code(from url: URL) -> String? {
        guard let urlComponents = URLComponents(string: url.absoluteString),
              urlComponents.path == "/oauth/authorize/native",
              let items = urlComponents.queryItems,
              let codeItem = items.first(where: { $0.name == "code" })
        else {
            print("URLComponents Error: Could not extract \"code\" item from url")
            return nil
        }
        
        return codeItem.value
    }
    
    // MARK: - Public Methods

    func authURL() -> URL? {        
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString) else {
            print("URLComponents Error: Authorize url string is corrupted")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            print("URLComponents Error: Could not create url from components")
            return nil
        }
        
        return url
    }
}
