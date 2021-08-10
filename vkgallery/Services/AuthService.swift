//
//  AuthService.swift
//  vkgallery
//
//  Created by Руслан Садыков on 09.08.2021.
//

import Foundation
import VK_ios_sdk

protocol AuthServiceDelegate: AnyObject {
    func authServiceShouldShow(viewController: UIViewController)
    func authServiceSignIn()
    func authServiceSignInDidFail()
}

final class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {
    
    static let shared = AuthService()
    
    private let appId = "7923018"
    private let vkSdk: VKSdk
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        print("Initialized vk sdk service")
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    weak var delegate: AuthServiceDelegate?
    
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }
    
    func wakeUpSession() {
        let scope = ["offline"]
        VKSdk.wakeUpSession(scope) { [delegate] state, error in
            switch state {
            
            case .unknown:
                break
            case .initialized:
                print("Initialized")
                VKSdk.authorize(scope)
            case .pending:
                break
            case .external:
                break
            case .safariInApp:
                break
            case .webview:
                break
            case .authorized:
                print("Authorized")
                delegate?.authServiceSignIn()
            case .error:
                print(error?.localizedDescription ?? "ERROR_LOG Unknown error while checking the authorization status")
            default:
                delegate?.authServiceSignInDidFail()
                print(error?.localizedDescription ?? "ERROR_LOG Unknown error while checking the authorization status")
            }
        }
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil {
            delegate?.authServiceSignIn()
        } else if let error = result.error  {
            print("ERROR_LOG Error auth: ", error.localizedDescription)
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        delegate?.authServiceSignInDidFail()
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        delegate?.authServiceShouldShow(viewController: controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        
    }
}
