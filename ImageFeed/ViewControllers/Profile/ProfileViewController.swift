//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Nikita Khon on 11.03.2025.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - Visual Components
    
    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "log_out_button"), for: .normal)
        button.addTarget(self, action: #selector(didTapLogOutButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Екатерина Новикова"
        label.textColor = .assetYpWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@ekaterina_nov"
        label.textColor = .assetYpGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, world!"
        label.textColor = .assetYpWhite
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    // MARK: - Private Properties
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let profileLogOutService = ProfileLogoutService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Actions
    
    @objc private func didTapLogOutButton() {
        showLogOutAlert()
    }
    
    // MARK: - Private Methods
    
    private func configure() {        
        view.backgroundColor = .assetYpBlack
        
        addSubviews()
        addConstraints()
    
        addObserver()
        updateAvatar()
        updateLabels()
    }
    
    private func addSubviews() {
        view.addSubview(avatarImage)
        view.addSubview(logOutButton)
        view.addSubview(fullNameLabel)
        view.addSubview(nicknameLabel)
        view.addSubview(statusLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            logOutButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logOutButton.widthAnchor.constraint(equalToConstant: 44),
            logOutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            fullNameLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            fullNameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            nicknameLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            statusLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func updateLabels() {
        fullNameLabel.text = profileService.profile?.name
        nicknameLabel.text = profileService.profile?.loginName
        statusLabel.text = profileService.profile?.bio
    }
    
    private func updateAvatar() {
        guard
            let avatarURL = profileImageService.avatarURLString,
            let url = URL(string: avatarURL)
        else {
            return
        }
        
        avatarImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_avatar"))
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
    
    private func showLogOutAlert() {
        let alertController = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.profileLogOutService.logout()
        }
        alertController.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "Нет", style: .default) { _ in }
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
