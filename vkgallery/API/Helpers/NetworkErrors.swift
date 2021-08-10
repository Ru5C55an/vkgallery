//
//  NetworkErrors.swift
//  vkgallery
//
//  Created by Руслан Садыков on 10.08.2021.
//

import Foundation

enum NetworkErrorType {
    case server
    case decoding
    case other(String)
}

struct NetworkError: Error {
    let type: NetworkErrorType
    let code: Int?
    let message: String?
}

extension NetworkError {
    init(_ type: NetworkErrorType, code: Int? = nil) {
        self.type = type
        self.code = code
        
        switch type {
            case .server: message = "Ошибка сервера: \(code ?? 0)"
            case .decoding: message = "Ошибка декодинга"
            case .other(let text): message = text
        }
    }
}
