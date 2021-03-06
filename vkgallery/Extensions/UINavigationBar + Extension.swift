//
//  UINavigationBar + Extension.swift
//  vkgallery
//
//  Created by Руслан Садыков on 10.08.2021.
//

import UIKit

extension UINavigationBar {
    
    func setupNavigationBarAppearance() {
        
        let bottomInset: CGFloat = -6
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = .systemBackground
        if let titleFont = UIFont.sfProDisplay(ofSize: 18, weight: .semibold) {
            coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.primaryColor, .font: titleFont]
        } else {
            coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.primaryColor, .font: UIFont.systemFont(ofSize: 18, weight: .semibold)]
            print("ERROR_LOG Error get sfProDisplay semibold font in set UINavigationBar appearance")
        }
        
        let buttonAppearance = UIBarButtonItemAppearance(style: .plain)
        if let buttonFont = UIFont.sfProDisplay(ofSize: 18, weight: .medium) {
            buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.primaryColor, .font: buttonFont]
        } else {
            buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.primaryColor, .font: UIFont.systemFont(ofSize: 18, weight: .medium)]
            print("ERROR_LOG Error get sfProDisplay semibold font in set UINavigationBar button color")
        }
        coloredAppearance.buttonAppearance = buttonAppearance
        
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.primaryColor]
        
        let backImage = UIImage(named: "back")?
            .withTintColor(.primaryColor, renderingMode: .alwaysOriginal)
            .withAlignmentRectInsets(
                UIEdgeInsets(top: 0, left: -10.75, bottom: bottomInset - 8, right: 0))
        coloredAppearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        coloredAppearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        
        coloredAppearance.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: bottomInset)
        coloredAppearance.buttonAppearance.normal.backgroundImagePositionAdjustment = UIOffset(horizontal: 0, vertical: bottomInset)
        coloredAppearance.buttonAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: bottomInset)
        coloredAppearance.backButtonAppearance.normal.backgroundImagePositionAdjustment = UIOffset(horizontal: 0, vertical: bottomInset)
        coloredAppearance.backButtonAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: bottomInset)
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
    }
}
