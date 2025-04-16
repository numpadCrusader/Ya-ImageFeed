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
    
    // MARK: - WebViewPresenterProtocol
    
    func viewDidLoad() {
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString) else {
            print("URLComponents Error: Authorize url string is corrupted")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            print("URLComponents Error: Could not create url from components")
            return
        }
        
        let request = URLRequest(url: url)
        
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
        guard let urlComponents = URLComponents(string: url.absoluteString),
              urlComponents.path == "/oauth/authorize/native",
              let items = urlComponents.queryItems,
              let codeItem = items.first(where: { $0.name == "code" })
        else {
            print("URLComponents Error: Could not extract \"code\" item from url")
            return nil
        }
        
        return codeItem.value
    }
    
    // MARK: - Public Methods
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
