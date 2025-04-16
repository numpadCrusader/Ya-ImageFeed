//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Nikita Khon on 17.04.2025.
//

import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didTapLogout() {}
    
    func performLogout() {}
}
