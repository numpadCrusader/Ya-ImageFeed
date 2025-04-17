//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Nikita Khon on 11.03.2025.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateLabels(name: String, nickname: String, bio: String)
    func updateAvatar(url: URL)
    func showLogoutAlert()
}

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
        button.accessibilityIdentifier = "logout button"
        return button
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .assetYpWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .assetYpGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .assetYpWhite
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    // MARK: - Public Properties
    
    var presenter: ProfilePresenterProtocol?
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @objc private func didTapLogOutButton() {
        presenter?.didTapLogout()
    }
    
    // MARK: - Private Methods
    
    private func configure() {        
        view.backgroundColor = .assetYpBlack
        
        addSubviews()
        addConstraints()
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
}

// MARK: - ProfileViewControllerProtocol

extension ProfileViewController: ProfileViewControllerProtocol {
    
    func updateLabels(name: String, nickname: String, bio: String) {
        fullNameLabel.text = name
        nicknameLabel.text = nickname
        statusLabel.text = bio
    }
    
    func updateAvatar(url: URL) {
        avatarImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_avatar"))
    }
    
    func showLogoutAlert() {
        let alertController = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert)
        
        alertController.view.accessibilityIdentifier = "Bye bye!"
        
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.performLogout()
        }
        yesAction.accessibilityIdentifier = "Yes"
        alertController.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "Нет", style: .default) { _ in }
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
