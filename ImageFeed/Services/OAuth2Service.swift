//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Nikita Khon on 07.04.2025.
//

import Foundation

final class OAuth2Service {
    
    // MARK: - Public Properties
    
    static let shared = OAuth2Service()
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Public Methods
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let tokenRequest = makeOAuthTokenRequest(code: code) else {
            return
        }
        
        let task = URLSession.shared.data(for: tokenRequest) { result in
            switch result {
                case .success(let data):
                    do {
                        let responseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                        completion(.success(responseBody.accessToken))
                    } catch {
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.unsplashTokenURLString) else {
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
