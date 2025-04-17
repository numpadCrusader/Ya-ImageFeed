//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Nikita Khon on 16.04.2025.
//

import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTapLogout()
    func performLogout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    // MARK: - Public Properties
    
    weak var view: ProfileViewControllerProtocol?
    
    // MARK: - Private Properties
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let profileLogOutService = ProfileLogoutService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - ProfilePresenterProtocol
    
    func viewDidLoad() {
        updateLabels()
        updateAvatar()
        addObserver()
    }
    
    func didTapLogout() {
        view?.showLogoutAlert()
    }
    
    func performLogout() {
        profileLogOutService.logout()
    }
    
    // MARK: - Private Methods
    
    private func updateLabels() {
        view?.updateLabels(
            name: profileService.profile?.name ?? "",
            nickname: profileService.profile?.loginName ?? "",
            bio: profileService.profile?.bio ?? "")
    }
    
    private func updateAvatar() {
        guard
            let avatarURL = profileImageService.avatarURLString,
            let url = URL(string: avatarURL)
        else {
            return
        }
        
        view?.updateAvatar(url: url)
    }
    
    private func addObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
    }
}
