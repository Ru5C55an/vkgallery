//
//  UINavigationBar + Extension.swift
//  vkgallery
//
//  Created by Руслан Садыков on 10.08.2021.
//

import UIKit

extension UINavigationBar {
    
    func setupNavigationBarAppearance() {
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
        coloredAppearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
    }
}