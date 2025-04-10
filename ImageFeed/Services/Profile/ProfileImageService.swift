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
    
    // MARK: - Private Properties
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private(set) var avatarURLString: String?
    
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
        
        let task = urlSession.data(for: profileRequest) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let data):
                    do {
                        let userDTO = try SnakeCaseJSONDecoder().decode(UserDTO.self, from: data)
                        self.avatarURLString = userDTO.profileImage.small
                        fulfillCompletionOnTheMainThread(.success(userDTO.profileImage.small))
                    } catch {
                        print("Decoding Error: Could not decode response body into JSON")
                        fulfillCompletionOnTheMainThread(.failure(error))
                    }
                    
                case .failure(let error):
                    print("Network Error: \(error.stringRepresentation)")
                    fulfillCompletionOnTheMainThread(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func makeProfileImageRequest(token: String, username: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.unsplashApiBaseURLString)/users/\(username)") else {
            print("URL Error: Profile url is corrupted")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
