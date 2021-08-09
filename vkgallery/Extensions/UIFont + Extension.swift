//
//  UIFont + Extension.swift
//  vkgallery
//
//  Created by Руслан Садыков on 10.08.2021.
//

import UIKit

extension UIFont {
    
    enum sfProDisplayWeight {
        case medium
        case semibold
        case bold
    }
    
    static func sfProDisplay(ofSize size: CGFloat, weight: sfProDisplayWeight) -> UIFont? {
        switch weight {
        case .medium:
            return UIFont.init(name: "SFProDisplay-Medium", size: size)
        case .semibold:
            return UIFont.init(name: "SFProDisplay-Semibold", size: size)
        case .bold:
            return UIFont.init(name: "SFProDisplay-Bold", size: size)
        }
    }
}
