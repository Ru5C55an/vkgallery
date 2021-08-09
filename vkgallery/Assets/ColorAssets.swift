//
//  ColorAssets.swift
//  vkgallery
//
//  Created by Руслан Садыков on 10.08.2021.
//

import UIKit

enum ColorAssets: String {
    
    // MARK: - Static
    case primaryColor
    
    var color: UIColor {
        return UIColor(named: self.rawValue) ?? UIColor()
    }
}

extension UIColor {
    public static var primaryColor:
        UIColor { return #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1) }
}

extension CGColor {
    public static var primaryColor:
        CGColor { return UIColor.primaryColor.cgColor }
}
