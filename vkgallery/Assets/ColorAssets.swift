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
    case btnTitleColor
    
    var color: UIColor {
        return UIColor(named: self.rawValue) ?? UIColor()
    }
}

extension UIColor {
    public static var primaryColor:
        UIColor { return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
            } else {
                /// Return the color for Light Mode
                return #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
            }
        }
    }
    
    public static var btnTitleColor:
        UIColor { return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return .black
            } else {
                /// Return the color for Light Mode
                return .white
            }
        }
    }
}

extension CGColor {
    public static var primaryColor:
        CGColor { return UIColor.primaryColor.cgColor }
    
    public static var btnTitleColor:
        CGColor { return UIColor.btnTitleColor.cgColor }
}
