//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Nikita Khon on 11.04.2025.
//

import Foundation

final class ProfileImageService {
    
    // MARK: - Public Properties
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    // MARK: - Private Properties
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private(set) var avatarURLString: String?
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Public Methods
    
    func fetchProfileImageURL(token: String, username: String, completion: @escaping (Result<String, Error>) -> Void) {
        task?.cancel()
        
        guard let profileRequest = makeProfileImageRequest(token: token, username: username) else {
            print("ProfileService Error: Could not create profile image request")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let fulfillCompletionOnTheMainThread: (Result<String, Error>) -> Void = { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.task = nil
                completion(result)
            }
        }
        
        let task = urlSession.objectTask(for: profileRequest) { [weak self] (result: Result<UserDTO, Error>) in
            guard let self = self else { return }
            
            switch result {
                case .success(let userDTO):
                    self.avatarURLString = userDTO.profileImage.medium
                    fulfillCompletionOnTheMainThread(.success(userDTO.profileImage.medium))
                    self.postNotification()
                    
                case .failure(let error):
                    print("ProfileService Error: Could not fetch profile image")
                    fulfillCompletionOnTheMainThread(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
    
    public func cleanUpService() {
        avatarURLString = nil
    }
    
    // MARK: - Private Methods
    
    private func makeProfileImageRequest(token: String, username: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.unsplashApiBaseURLString)/users/\(username)") else {
            print("URL Error: Profile image url is corrupted")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func postNotification() {
        NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self)
    }
}
