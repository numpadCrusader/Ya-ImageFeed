//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Nikita Khon on 08.04.2025.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    
    var stringRepresentation: String {
        switch self {
            case .httpStatusCode(let int):
                "Status code error \(int)"
                
            case .urlRequestError(let error):
                "URL request error. \(error)"
                
            case .urlSessionError:
                "URL session error"
        }
    }
}
