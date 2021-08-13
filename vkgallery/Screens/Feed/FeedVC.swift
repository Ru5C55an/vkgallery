//
//  FeedVC.swift
//  vkgallery
//
//  Created by Руслан Садыков on 10.08.2021.
//

import UIKit
import Kingfisher
import SPAlert

final class FeedVC: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let ownerId = "-128666765"
        static let albumId = "266276915"
        
        static let navTitle = "Mobile Up Gallery"
        static let exitButtonTitle = NSLocalizedString(LocalizedStringKeys.kExit, comment: "Выход")
        static let itemsPerRow: CGFloat = 2
        static let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let itemSpacing: CGFloat = 2
    }
    
    // MARK: - UI Elements
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = Constants.itemSpacing
        flowLayout.minimumLineSpacing = Constants.itemSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.refreshControl = refreshControl
        return collectionView
    }()
    
    // MARK: - Properties
    private let authService = AuthService.shared
    private var photos: [PhotoModel] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        getPhotos()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.standardAppearance.shadowColor = .clear
    }
    
    deinit {
        print("Deinitialized FeedVC")
    }
    
    // MARK: - Refresh
    @objc private func refresh(_ sender: UIRefreshControl) {
        getPhotos {
            sender.endRefreshing()
        }
    }
    
    // MARK: - Get photos
    private func getPhotos(completion: (() -> ())? = nil) {
        let request = GetPhotosRequest(ownerId: Constants.ownerId, albumId: Constants.albumId)
        PhotosAPI.getPhotos(request: request) { [weak self] result in
            switch result {
            
            case .success(let response):
                print("Successfull get photos for ownerId \(Constants.ownerId), albumId \(Constants.albumId): ", response)
                self?.photos = response.response.items
                self?.collectionView.reloadData()
                completion?()
            case .failure(let error):
                completion?()
                print("ERROR_LOG Error get photos from album \(Constants.albumId), owner \(Constants.ownerId): ", error.message)
                let errorAlert = SPAlertView(title: NSLocalizedString(LocalizedStringKeys.kErrorGetPhotosFromAlbum, comment: "Ошибка получения фото с альбома"), message: error.message, preset: .error)
                errorAlert.dismissByTap = true
                errorAlert.present(duration: 5, haptic: .error, completion: nil)
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
    
    // MARK: - Handlers
    @objc private func exitAction() {
        let alertController = UIAlertController(title: NSLocalizedString(LocalizedStringKeys.kExit, comment: "Выход"), message: NSLocalizedString(LocalizedStringKeys.kAreYouSure, comment: "Вы уверены?"), preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: NSLocalizedString(LocalizedStringKeys.kYes, comment: "Да"), style: .destructive) { [weak self] _ in
            self?.authService.logout()
        }
        let cancleAciton = UIAlertAction(title: NSLocalizedString(LocalizedStringKeys.kCancel, comment: "Отмена"), style: .cancel, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(cancleAciton)
        present(alertController, animated: true, completion: nil)
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
        guard let photo = photos[indexPath.row].sizes.last else {
            print("ERROR_LOG Error get photo for index path \(indexPath)")
            return UICollectionViewCell()
        }
        
        let imageUrl = photo.url
        let imageSize = CGSize(width: photo.width, height: photo.height)
        cell.imageView.setImage(imageUrl: imageUrl, size: imageSize)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let fullscreenPhotosVC = FullscreenPhotosVC(images: photos, selectedImage: photo)
        navigationController?.pushViewController(fullscreenPhotosVC, animated: true)
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
