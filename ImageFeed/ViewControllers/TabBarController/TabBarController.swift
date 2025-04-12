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
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        let profileViewController = makeProfileViewController()
        
        viewControllers = [imagesListViewController, profileViewController]
    }
    
    // MARK: - Private Methods
    
    private func makeProfileViewController() -> UIViewController {
        let profileViewController = ProfileViewController()
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)
        
        return profileViewController
    }
}
