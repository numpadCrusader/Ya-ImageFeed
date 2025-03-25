//
//  UIColor+Extensions.swift
//  ImageFeed
//
//  Created by Nikita Khon on 25.03.2025.
//

import UIKit

extension UIColor {
    static var assetYpBackground: UIColor { UIColor(named: "YP Background") ?? UIColor.black.withAlphaComponent(0.5) }
    static var assetYpBlack: UIColor { UIColor(named: "YP Black") ?? UIColor.black }
    static var assetYpBlue: UIColor { UIColor(named: "YP Blue") ?? UIColor.systemBlue }
    static var assetYpGray: UIColor { UIColor(named: "YP Gray") ?? UIColor.systemGray3 }
    static var assetYpRed: UIColor { UIColor(named: "YP Red") ?? UIColor.systemRed }
    static var assetYpWhite: UIColor { UIColor(named: "YP White") ?? UIColor.white }
    static var assetYpWhiteAlpha50: UIColor { UIColor(named: "YP White Alpha 50") ?? UIColor.white.withAlphaComponent(0.5) }
}
