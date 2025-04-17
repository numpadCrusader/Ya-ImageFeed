//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Nikita Khon on 16.04.2025.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    
    // MARK: - Public Properties
    
    weak var view: WebViewViewControllerProtocol?
    
    // MARK: - Private Properties
    
    private var authHelper: AuthHelperProtocol
    
    // MARK: - Initializers
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    // MARK: - WebViewPresenterProtocol
    
    func viewDidLoad() {
        guard let request = authHelper.authRequest() else { return }
        didUpdateProgressValue(0)
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func code(from url: URL) -> String?{
        authHelper.code(from: url)
    }
    
    // MARK: - Public Methods
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
