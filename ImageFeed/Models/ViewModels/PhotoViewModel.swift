//
//  PhotoViewModel.swift
//  ImageFeed
//
//  Created by Nikita Khon on 13.04.2025.
//

import Foundation

struct PhotoViewModel {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
}

extension PhotoViewModel {
     
    init(from photoDTO: PhotoDTO) {
        id = photoDTO.id
        size = CGSize(width: photoDTO.width, height: photoDTO.height)
        createdAt = photoDTO.createdAt.date
        welcomeDescription = photoDTO.description
        thumbImageURL = photoDTO.urls.thumb
        largeImageURL = photoDTO.urls.regular
        isLiked = photoDTO.likedByUser
    }
}
