//
//  VKAPI.swift
//  vkgallery
//
//  Created by Руслан Садыков on 10.08.2021.
//

import Foundation

private struct Constants {
    static let version = "5.131"
}

private struct EndPoints {
    static let photos = "/method/photos.get"
}

class PhotosAPI {
    static func getPhotos(request: GetPhotosRequest, completion: @escaping (Swift.Result<GetPhotosResponse, NetworkError>) -> Void) {
        var parameters = request.dictionary
        parameters?["v"] = Constants.version
        BaseAPI.authorizedGetRequest(endPoint: EndPoints.photos, parameters: parameters, success:{ (data) in
            if let data = data {
                RequestDecoder.decode(data: data, parseFromRootKey: nil, completion: completion)
            } else {
                completion(.failure(NetworkError(.server)))
            }
        }) { (error) in
            completion(.failure(error ?? NetworkError(.server)))
        }
    }
}
