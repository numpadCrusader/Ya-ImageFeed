//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Nikita Khon on 07.04.2025.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private var webView: WKWebView!
    
    // MARK: - IBAction
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
