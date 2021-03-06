//
//  PhotoModel.swift
//  vkgallery
//
//  Created by Руслан Садыков on 10.08.2021.
//

import Foundation

struct PhotoModel: Codable {
    let albumId: Int
    let date: TimeInterval
    let hasTags: Bool
    let id: Int
    let ownerId: Int
    let sizes: [PhotoSizeModel]
}

struct PhotoSizeModel: Codable {
    let height: Int
    let type: String
    let url: URL
    let width: Int
}
