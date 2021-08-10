//
//  StatusMessage.swift
//  vkgallery
//
//  Created by Руслан Садыков on 10.08.2021.
//

import Foundation

struct StatusMessage: Codable {
    let error: ErrorModel?
}

struct ErrorModel: Codable {
    let errorCode: Int
    let errorMsg: String
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorMsg = "error_msg"
    }
}
