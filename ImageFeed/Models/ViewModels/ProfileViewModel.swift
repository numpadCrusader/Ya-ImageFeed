//
//  ProfileViewModel.swift
//  ImageFeed
//
//  Created by Nikita Khon on 10.04.2025.
//

import Foundation

struct ProfileViewModel {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}

extension ProfileViewModel {
    
    init(from profileDTO: ProfileDTO) {
        username = profileDTO.username
        name = "\(profileDTO.firstName) \(profileDTO.lastName ?? "")"
        loginName = "@\(profileDTO.username)"
        bio = profileDTO.bio
    }
}
