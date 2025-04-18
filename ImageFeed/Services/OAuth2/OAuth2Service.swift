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
    
    // MARK: - Private Properties
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Public Methods
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            print("OAuth2Service Error: Overlapping request")
            completion(.failure(OAuth2ServiceError.invalidRequest))
            return
        }

        task?.cancel()
        lastCode = code
        
        guard let tokenRequest = makeOAuthTokenRequest(code: code) else {
            print("OAuth2Service Error: Could not create auth token request")
            completion(.failure(OAuth2ServiceError.invalidRequest))
            return
        }
        
        let fulfillCompletionOnTheMainThread: (Result<String, Error>) -> Void = { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                completion(result)
                self.task = nil
                self.lastCode = nil
            }
        }
        
        let task = urlSession.objectTask(for: tokenRequest) { (result: Result<OAuthTokenDTO, Error>) in
            switch result {
                case .success(let oAuthTokenDTO):
                    fulfillCompletionOnTheMainThread(.success(oAuthTokenDTO.accessToken))
                    
                case .failure(let error):
                    print("OAuth2Service Error: Could not fetch auth token")
                    fulfillCompletionOnTheMainThread(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.unsplashTokenURLString) else {
            print("URLComponents Error: Token url string is corrupted")
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
            print("URLComponents Error: Could not create url from components")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
