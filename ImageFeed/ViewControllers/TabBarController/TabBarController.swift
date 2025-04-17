//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Nikita Khon on 11.04.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - UITabBarController
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let imagesListViewController = makeImagesListViewController()
        let profileViewController = makeProfileViewController()
        
        viewControllers = [imagesListViewController, profileViewController]
    }
    
    // MARK: - Private Methods
    
    private func makeImagesListViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard
            let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController
        else {
            print("Could not create proper ImagesListViewController")
            return UIViewController()
        }
        
        let imagesListPresenter = ImagesListPresenter()
        imagesListViewController.configure(imagesListPresenter)
        
        return imagesListViewController
    }
    
    private func makeProfileViewController() -> UIViewController {
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter()
        
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)
        
        return profileViewController
    }
}
