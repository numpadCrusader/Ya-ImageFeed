//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Nikita Khon on 08.04.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Visual Components
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "splash_screen_logo")
        imageView.contentMode = .center
        return imageView
    }()
    
    // MARK: - Private Properties
    
    private let oAuth2TokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private let tabBarControllerStoryboardIdentifier = "TabBarViewController"
    private let authViewControllerStoryboardIdentifier = "AuthViewController"
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard oAuth2TokenStorage.isTokenFresh else {
            presentAuthViewController()
            return
        }
        
        guard let token = oAuth2TokenStorage.token else {
            presentAuthViewController()
            return
        }
        
        fetchProfile(token: token)
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        view.backgroundColor = .assetYpBlack
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(logoImageView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: tabBarControllerStoryboardIdentifier)
           
        window.rootViewController = tabBarController
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            
            switch result {
                case .success(let profileDTO):
                    self.profileImageService.fetchProfileImageURL(token: token, username: profileDTO.username) { _ in }
                    self.switchToTabBarController()
                    
                case .failure:
                    break
            }
        }
    }
    
    private func presentAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard 
            let authVC = storyboard.instantiateViewController(withIdentifier: authViewControllerStoryboardIdentifier) as? AuthViewController
        else {
            print("presentAuthViewController Error: Could not create AuthViewController")
            return
        }
        
        authVC.delegate = self
        authVC.modalPresentationStyle = .overFullScreen
        
        present(authVC, animated: true)
    }
}

// MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true) { [weak self] in
            guard 
                let self = self,
                let token = oAuth2TokenStorage.token
            else {
                print("Error: Could not fetch token")
                return
            }
            
            self.fetchProfile(token: token)
        }
    }
}
