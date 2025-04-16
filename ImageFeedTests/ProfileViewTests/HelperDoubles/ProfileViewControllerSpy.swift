//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Nikita Khon on 16.04.2025.
//

import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var didUpdateLabels = false
    var didUpdateAvatar = false
    var didShowAlert = false
    
    func updateLabels(name: String, nickname: String, bio: String) {
        didUpdateLabels = true
    }
    
    func updateAvatar(url: URL) {
        didUpdateAvatar = true
    }
    
    func showLogoutAlert() {
        didShowAlert = true
    }
}
