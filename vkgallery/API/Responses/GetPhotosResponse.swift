//
//  GetPhotosResponse.swift
//  vkgallery
//
//  Created by Руслан Садыков on 10.08.2021.
//

import Foundation

struct GetPhotosResponse: Codable {
    let response: PhotosResponse
}

struct PhotosResponse: Codable {
    let items: [PhotoModel]
    let count: Int
}
