//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Nikita Khon on 16.04.2025.
//

import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var loadRequestCalled = false
    var presenter: WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {}
    
    func setProgressHidden(_ isHidden: Bool) {}
}
