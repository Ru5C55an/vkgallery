//
//  SceneDelegate.swift
//  vkgallery
//
//  Created by Руслан Садыков on 09.08.2021.
//

import UIKit
import VK_ios_sdk

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
//    static func shared() -> SceneDelegate {
//        let scene = UIApplication.shared.connectedScenes.first
//        let sceneDelegate: SceneDelegate = scene?.delegate as! SceneDelegate
//        return sceneDelegate
//    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let windowsScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowsScene.coordinateSpace.bounds)
        window?.windowScene = windowsScene
        AuthService.shared.delegate = self
        let authVC = AuthVC()
        window?.rootViewController = authVC
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
        window?.rootViewController = navigationController
    }
    
    func authServiceSignInDidFail() {
        
    }
}
