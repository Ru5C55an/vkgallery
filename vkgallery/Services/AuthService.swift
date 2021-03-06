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
    func authServiceSignInDidFail(errorMessage: String)
    func authServiceLogout()
    func authServiceNeedCaptcha(error: VKError)
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
    
    func wakeUpSession(isNeedRoute: Bool = true) {
        let scope = ["offline"]
        VKSdk.wakeUpSession(scope) { [delegate] state, error in
            switch state {
            
            case .unknown:
                break
            case .initialized:
                print("Initialized")
                VKSdk.authorize(scope)
            case .authorized:
                print("Authorized")
                if isNeedRoute {
                    delegate?.authServiceSignIn()
                }
            case .error:
                print(error?.localizedDescription ?? "ERROR_LOG Unknown error while checking the authorization status")
                delegate?.authServiceSignInDidFail(errorMessage: error?.localizedDescription ?? NSLocalizedString(LocalizedStringKeys.kCheckStatusError, comment: "Неизвестная ошибка при проверке статуса авторизации"))
            default:
                print(error?.localizedDescription ?? "ERROR_LOG Unknown error while checking the authorization status")
                delegate?.authServiceSignInDidFail(errorMessage: error?.localizedDescription ?? NSLocalizedString(LocalizedStringKeys.kDefaultAuthError, comment: "Проверка статуса авторизации вернула неизвестный статус"))
            }
        }
    }
    
    func checkAuth(completion: @escaping ((Bool) -> Void)) {
        let scope = ["offline"]
        VKSdk.wakeUpSession(scope) { state, error in
            switch state {
            
            case .authorized:
                print("Authorized")
                completion(true)
            case .error:
                completion(false)
                print(error?.localizedDescription ?? "ERROR_LOG Unknown error while checking the authorization status")
            default:
                completion(false)
                print(error?.localizedDescription ?? "ERROR_LOG Not authorized")
            }
        }
    }
    
    func logout() {
        VKSdk.forceLogout()
        delegate?.authServiceLogout()
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil {
            delegate?.authServiceSignIn()
        } else if let error = result.error  {
            print("ERROR_LOG Error auth: ", error.localizedDescription)
            delegate?.authServiceSignInDidFail(errorMessage: error.localizedDescription)
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        delegate?.authServiceSignInDidFail(errorMessage: NSLocalizedString(LocalizedStringKeys.kCheckStatusError, comment: "Неизвестная ошибка при проверке статуса авторизации"))
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        delegate?.authServiceShouldShow(viewController: controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        delegate?.authServiceNeedCaptcha(error: captchaError)
    }
    
    func vkSdkTokenHasExpired(_ expiredToken: VKAccessToken!) {
        wakeUpSession(isNeedRoute: false)
    }
}
