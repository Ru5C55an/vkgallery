//
//  BaseAPI.swift
//  vkgallery
//
//  Created by Руслан Садыков on 10.08.2021.
//

import Foundation
import Alamofire

class BaseAPI {

    static let baseURL = "https://api.vk.com"
    static let authorizedSession = Session(interceptor: RequestInterceptor())
    
    private static let headers: HTTPHeaders = {
        var headers = ["Accept": "application/json"]
        return HTTPHeaders(headers)
    }()
    
    private static func request(method: HTTPMethod, endPoint: String, parameters: [String: Any]?, success: @escaping (Data?) -> Void, failure: @escaping (NetworkError?) -> Void) {

        authorizedSession.request(URL(string: "\(BaseAPI.baseURL)\(endPoint)")!,
                                  method: method,
                                  parameters: parameters,
                                  encoding: URLEncoding.default,
                                  headers: BaseAPI.headers)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                print("JSON Status: \(String(describing: response.response?.statusCode)), Response:", response)
                
                guard response.response?.statusCode != 429 else {
                    let error = NetworkError(.other("Слишком много запросов"), code: response.response?.statusCode)
                    failure(error)
                    return
                }
                
                guard response.response?.statusCode != 500, response.response?.statusCode != 405 else {
                    failure(NetworkError(.server, code: response.response?.statusCode))
                    return
                }
                
                guard response.response?.statusCode != -1001 else {
                    let error = NetworkError(.other("Превышено время ожидания"), code: -1001)
                    failure(error)
                    return
                }
                
                guard response.response?.statusCode != 403 else {
                    let error = NetworkError(.other("Ошибка авторизации"), code: 403)
                    failure(error)
                    return
                }
                
                guard response.response?.statusCode != 404 else {
                    let error = NetworkError(.other("Ошибка 404"), code: 404)
                    failure(error)
                    return
                }
                
                guard response.response?.statusCode != 503 else {
                    let error = NetworkError(.other("Сервис временно недоступен, попробуйте повторить запрос позже"), code: 503)
                    failure(error)
                    return
                }
                
                if let data = response.data {
                    if response.response?.statusCode == 429 {
                        let error = NetworkError(.other("Слишком много запросов"), code: response.response?.statusCode)
                        failure(error)
                        return
                    }
                    success(data)
                } else {
                    if response.response?.statusCode == 200 {
                        success(response.data)
                        return
                    }
                    
                    failure(NetworkError(.server, code: response.response?.statusCode))
                }
            }
    }
    
    static func authorizedGetRequest(endPoint: String, parameters: [String: Any]?, success: @escaping (Data?) -> Void, failure: @escaping (NetworkError?) -> Void) {

        guard let token = AuthService.shared.token else {
            failure(NetworkError(.other("Error get token from AuthService")))
            return
        }
        var parameters = parameters
        parameters?["access_token"] = token
        request(method: .get, endPoint: endPoint, parameters: parameters, success: success, failure: failure)
    }
}
