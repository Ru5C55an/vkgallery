//
//  FeedVC.swift
//  vkgallery
//
//  Created by Руслан Садыков on 10.08.2021.
//

import UIKit
import Kingfisher

final class FeedVC: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let ownerId = "-128666765"
        static let albumId = "266276915"
        
        static let navTitle = "Mobile Up Gallery"
        static let exitButtonTitle = "Выход"
        static let itemsPerRow: CGFloat = 2
        static let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let itemSpacing: CGFloat = 2
    }
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.minimumLineSpacing = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - Properties
    private let authService = AuthService.shared
    private var photos: [PhotoSizeModel] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        getPhotos()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Get photos
    private func getPhotos() {
        if !photos.isEmpty { photos.removeAll() }
        let request = GetPhotosRequest(ownerId: Constants.ownerId, albumId: Constants.albumId)
        PhotosAPI.getPhotos(request: request) { result in
            switch result {
            
            case .success(let response):
                print("Successfull get photos for ownerId \(Constants.ownerId), albumId \(Constants.albumId): ", response)
                response.response.items.forEach { [weak self] photoItem in
                    guard let photoSize = photoItem.sizes.last else { return }
                    self?.photos.append(photoSize)
                }
                self.collectionView.reloadData()
            case .failure(let error):
                print("ERROR_LOG Error get photos from album user: ", error.message)
            }
        }
    }
    
    // MARK: - Setup nav bar
    private func setupNavBar() {
        navigationItem.title = Constants.navTitle
        let exitButton = UIBarButtonItem(title: Constants.exitButtonTitle, style: .plain, target: self, action: #selector(exitAction))
        navigationItem.rightBarButtonItem = exitButton
    }
    
    // MARK: - Setup views
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    // MARK: - Setup constraints
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setImage(for cell: PhotoCell, imageUrl: URL, size: CGSize) {
        let processor = DownsamplingImageProcessor(size: size)
        var loadingIndicator = ImageIndicator()
        cell.imageView.kf.indicatorType = .custom(indicator: loadingIndicator)
        cell.imageView.kf.setImage(
            with: imageUrl,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
//                .transition(.fade(1)),
                .cacheOriginalImage
            ],
            progressBlock: { receivedSize, totalSize in
                let percentage = CGFloat(receivedSize) / CGFloat(totalSize)
                loadingIndicator.percentage = percentage
                print("Progress: \(percentage * 100.0)%")
            })
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Handlers
    @objc private func exitAction() {

    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FeedVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath as IndexPath) as? PhotoCell
        else {
            print("ERROR_LOG Error get PhotoCell for index path \(indexPath)")
            return UICollectionViewCell() }
        let photo = photos[indexPath.row]
        let imageUrl = photo.url
        let imageSize = CGSize(width: photo.width, height: photo.height)
        setImage(for: cell, imageUrl: imageUrl, size: imageSize)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FeedVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(Constants.itemsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(Constants.itemsPerRow))
        return CGSize(width: size, height: size)
    }
}
