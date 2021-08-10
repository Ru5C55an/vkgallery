//
//  FeedVC.swift
//  vkgallery
//
//  Created by Руслан Садыков on 10.08.2021.
//

import UIKit

final class FeedVC: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let ownerId = "-128666765"
        static let albumId = "266276915"
    }
    
    // MARK: - Properties
    private let authService = AuthService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = GetPhotosRequest(ownerId: Constants.ownerId, albumId: Constants.albumId)
        PhotosAPI.getPhotos(request: request) { result in
            switch result {
            
            case .success(let response):
                print("Successfull get photos for ownerId \(Constants.ownerId), albumId \(Constants.albumId): ", response)
            case .failure(let error):
                print("ERROR_LOG Error get photos from album user")
            }
        }
    }
}
