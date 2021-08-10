//
//  RequestInterceptor.swift
//  vkgallery
//
//  Created by Руслан Садыков on 10.08.2021.
//

import Alamofire

final class RequestInterceptor: Alamofire.RequestInterceptor {

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            /// The request did not fail due to a 401 Unauthorized response.
            /// Return the original error and don't retry the request.
            return completion(.doNotRetryWithError(error))
        }
    }
}

