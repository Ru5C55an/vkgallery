//
//  RequestDecoder.swift
//  vkgallery
//
//  Created by Руслан Садыков on 10.08.2021.
//

import Foundation

class RequestDecoder {
    static func decode<T: Decodable>(data: Data, parseFromRootKey: String? = nil, completion: @escaping (Swift.Result<T, NetworkError>) -> Void) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let result = try decoder.decode(T.self, from: data, keyedBy: parseFromRootKey)
            completion(.success(result))
        } catch let error {
            RequestDecoder.errorDecoder(data: data, completion: completion)
            print("Object parse error:", error)
        }
    }
    
    static func errorDecoder<T: Decodable>(data: Data, completion: @escaping (Swift.Result<T, NetworkError>) -> Void) {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(StatusMessage.self, from: data, keyedBy: nil)
            completion(.failure(NetworkError(type: .server, code: result.error?.errorCode, message: result.error?.errorMsg ?? NSLocalizedString(LocalizedStringKeys.kUnknownError, comment: "Неизвестная ошибка"))))
        } catch let error {
            print("Error parse error:", error)
            completion(.failure(NetworkError(.decoding)))
        }
    }
}

