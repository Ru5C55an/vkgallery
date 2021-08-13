//
//  SceneDelegate.swift
//  vkgallery
//
//  Created by Руслан Садыков on 09.08.2021.
//

import UIKit
import VK_ios_sdk
import SPAlert

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let windowsScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowsScene.coordinateSpace.bounds)
        window?.windowScene = windowsScene
        AuthService.shared.delegate = self
        
        AuthService.shared.checkAuth(completion: { [window] isAuthentificated in
            if isAuthentificated {
                let feedVC = FeedVC()
                let navigationController = UINavigationController(rootViewController: feedVC)
                navigationController.navigationBar.setupNavigationBarAppearance()
                window?.rootViewController = navigationController
            } else {
                let authVC = AuthVC()
                window?.rootViewController = authVC
            }
        })
        
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        }
    }
}

// MARK: - AuthServiceDelegate
extension SceneDelegate: AuthServiceDelegate {
    func authServiceShouldShow(viewController: UIViewController) {
        window?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func authServiceSignIn() {
        let feedVC = FeedVC()
        let navigationController = UINavigationController(rootViewController: feedVC)
        navigationController.navigationBar.setupNavigationBarAppearance()
        navigationController.additionalSafeAreaInsets = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        window?.rootViewController = navigationController
    }
    
    func authServiceSignInDidFail(errorMessage: String) {
        let errorAlert = SPAlertView(title: errorMessage, preset: .error)
        errorAlert.dismissByTap = true
        errorAlert.presentWindow = window
        errorAlert.present(duration: 5, haptic: .error, completion: nil)
    }
    
    func authServiceNeedCaptcha(error: VKError) {
        let captchaVC = VKCaptchaViewController()
        captchaVC.present(in: window?.rootViewController)
    }
    
    func authServiceLogout() {
        let authVC = AuthVC()
        window?.rootViewController = authVC
    }
}
