//
//  GetPhotoRequest.swift
//  vkgallery
//
//  Created by Руслан Садыков on 10.08.2021.
//

import Foundation

struct GetPhotosRequest: Codable {
    let ownerId: String
    let albumId: String
    
    enum CodingKeys: String, CodingKey {
        case ownerId = "owner_id"
        case albumId = "album_id"
    }
}
