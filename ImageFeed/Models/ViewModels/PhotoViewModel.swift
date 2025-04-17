//
//  PhotoViewModel.swift
//  ImageFeed
//
//  Created by Nikita Khon on 13.04.2025.
//

import Foundation

public struct PhotoViewModel {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

extension PhotoViewModel {
     
    init(from photoDTO: PhotoDTO) {
        id = photoDTO.id
        size = CGSize(width: photoDTO.width, height: photoDTO.height)
        createdAt = photoDTO.createdAt.date
        welcomeDescription = photoDTO.description
        thumbImageURL = photoDTO.urls.regular
        largeImageURL = photoDTO.urls.full
        isLiked = photoDTO.likedByUser
    }
}
