//
//  URLSession+Data.swift
//  ImageFeed
//
//  Created by Nikita Khon on 07.04.2025.
//

import Foundation

extension URLSession {
    
    // MARK: - Public Methods
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        
        let task = data(for: request) { result in
            switch result {
                case .success(let data):
                    do {
                        let decodedResponseBody = try SnakeCaseJSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedResponseBody))
                    } catch {
                        print("Decoding Error: Could not decode response body into JSON")
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    print("Network Error: \(error.stringRepresentation)")
                    completion(.failure(error))
            }
        }
        
        return task
    }
    
    // MARK: - Private Methods
    
    private func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) -> URLSessionTask {
        
        let fulfillCompletionOnTheMainThread: (Result<Data, NetworkError>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
}
