//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Nikita Khon on 13.04.2025.
//

import Foundation

final class ImagesListService {
    
    // MARK: - Public Properties
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // MARK: - Private Properties
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    
    private var photosIdSet = Set<String>()
    private (set) var photos: [PhotoViewModel] = []
    
    // MARK: - Initializers
    
    private init() {}

    // MARK: - Public Methods
    
    func fetchPhotosNextPage(token: String, completion: @escaping (Result<[PhotoDTO], Error>) -> Void) {
        guard task == nil else {
            print("ImagesListService Error: Could not create overlapping request")
            completion(.failure(ImagesListServiceError.overlappingRequest))
            return
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let photosRequest = makePhotosRequest(token: token, page: nextPage) else {
            print("ImagesListService Error: Could not create photos request")
            completion(.failure(ImagesListServiceError.invalidRequest))
            return
        }
        
        let fulfillCompletionOnTheMainThread: (Result<[PhotoDTO], Error>) -> Void = { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.task = nil
                completion(result)
            }
        }
        
        let task = urlSession.objectTask(for: photosRequest) { [weak self] (result: Result<[PhotoDTO], Error>) in
            guard let self = self else { return }
            
            switch result {
                case .success(let photos):
                    self.lastLoadedPage = nextPage
                    self.appendNewPhotos(photos)
                    fulfillCompletionOnTheMainThread(.success(photos))
                    
                case .failure(let error):
                    print("ImagesListService Error: Could not fetch photos")
                    fulfillCompletionOnTheMainThread(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func makePhotosRequest(token: String, page: Int) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "\(Constants.unsplashApiBaseURLString)/photos") else {
            print("URLComponents Error: Get photos URL string is corrupted")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        
        guard let url = urlComponents.url else {
            print("URLComponents Error: Could not create photos url from components")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func appendNewPhotos(_ newPhotosDto: [PhotoDTO]) {
        var newPhotosVM: [PhotoViewModel] = []
        
        for photoDTO in newPhotosDto {
            if photosIdSet.contains(photoDTO.id) {
                continue
            }
            
            photosIdSet.insert(photoDTO.id)
            newPhotosVM.append(PhotoViewModel(from: photoDTO))
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.photos.append(contentsOf: newPhotosVM)
            self.postNotification()
        }
    }
    
    private func postNotification() {
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
    }
}
