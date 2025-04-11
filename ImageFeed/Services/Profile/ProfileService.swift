//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Nikita Khon on 10.04.2025.
//

import Foundation

final class ProfileService {
    
    // MARK: - Public Properties
    
    static let shared = ProfileService()
    
    // MARK: - Private Properties
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private(set) var profile: ProfileViewModel?
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Public Methods
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileDTO, Error>) -> Void) {
        task?.cancel()
        
        guard let profileRequest = makeProfileRequest(token: token) else {
            print("ProfileService Error: Could not create profile request")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let fulfillCompletionOnTheMainThread: (Result<ProfileDTO, Error>) -> Void = { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.task = nil
                completion(result)
            }
        }
        
        let task = urlSession.objectTask(for: profileRequest) { [weak self] (result: Result<ProfileDTO, Error>) in
            guard let self = self else { return }
            
            switch result {
                case .success(let profileDTO):
                    self.profile = ProfileViewModel(from: profileDTO)
                    fulfillCompletionOnTheMainThread(.success(profileDTO))
                    
                case .failure(let error):
                    fulfillCompletionOnTheMainThread(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.unsplashApiBaseURLString)/me") else {
            print("URL Error: Profile url is corrupted")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
