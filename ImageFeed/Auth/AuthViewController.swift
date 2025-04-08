//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Nikita Khon on 07.04.2025.
//

import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    // MARK: - UIViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        OAuth2Service.shared.fetchOAuthToken(code: code) { result in
            switch result {
                case .success(let success):
                    print("Token \(success)")
                    
                case .failure(let failure):
                    print(failure)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
