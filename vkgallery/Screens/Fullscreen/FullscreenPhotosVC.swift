//
//  FullscreenPhotosVC.swift
//  vkgallery
//
//  Created by Руслан Садыков on 11.08.2021.
//

import UIKit
import Kingfisher
import SPAlert

final class FullscreenPhotosVC: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let itemSpacing: CGFloat = 2
        static let bottomNavLineColor: UIColor = .black.withAlphaComponent(0.1)
    }
    
    // MARK: - UI Elements
    private lazy var fullscreenImagesCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ZommablePhotoCell.self, forCellWithReuseIdentifier: ZommablePhotoCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    private lazy var smallImagesCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = Constants.itemSpacing
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var shareBarButtonItem: UIBarButtonItem = {
        let shareImage = UIImage(named: "share")?.withTintColor(.primaryColor, renderingMode: .alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image: shareImage, style: .plain, target: self, action: #selector(shareAction))
        return barButtonItem
    }()
    
    // MARK: - Haptic feedback
    private let generator = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: - Properties
    private let images: [PhotoModel]
    private var selectedImage: PhotoModel
    private let indexForSelectedImage: Int?
    private var prevIndex = 0
    
    // MARK: - Init
    init(images: [PhotoModel], selectedImage: PhotoModel) {
        self.images = images
        self.selectedImage = selectedImage
        self.indexForSelectedImage = images.firstIndex(where: { photo in
            photo.id == selectedImage.id
        })
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupViews()
        setupConstraints()
        prevIndex = indexForSelectedImage ?? 0
        scrollToSelectedImage()
    }
    
    deinit {
        print("Deinitialized ", FullscreenPhotosVC.self)
    }
    
    // MARK: - setupNavBar
    private func setupNavBar() {
        setTitleWith(timeInterval: selectedImage.date)
        navigationController?.navigationBar.standardAppearance.shadowColor = Constants.bottomNavLineColor
        navigationItem.rightBarButtonItem = shareBarButtonItem
    }
    
    // MARK: - Setup views
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(smallImagesCollectionView)
        view.addSubview(fullscreenImagesCollectionView)
    }
    
    // MARK: - Setup constraints
    private func setupConstraints() {
        fullscreenImagesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(smallImagesCollectionView.snp.top)
        }
        
        smallImagesCollectionView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: - Scroll to selected image
    private func scrollToSelectedImage() {
        DispatchQueue.main.async {
            self.fullscreenImagesCollectionView.scrollToItem(at: [0, self.indexForSelectedImage ?? 0], at: .centeredHorizontally, animated: false)
            self.smallImagesCollectionView.scrollToItem(at: [0, self.indexForSelectedImage ?? 0], at: .centeredHorizontally, animated: false)
        }
    }
    
    // MARK: - Setup date title
    private func setTitleWith(timeInterval: TimeInterval) {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateString = DateFormatter.ddMMMMyyyy.string(from: date)
        navigationItem.title = dateString
    }
    
    // MARK: - Set fullscreen image
    private func setImageFor(imageScrollView: ImageScrollView, url: URL, completion: ((UIImage) -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.getImage(by: url) { image in
                completion?(image)
                imageScrollView.set(image: image)
            }
        }
    }
    
    private func getImage(by url: URL, completion: @escaping ((UIImage) -> Void)) {
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            
            case .success(let retrieveImageResult):
                completion(retrieveImageResult.image)
            case .failure(let error):
                let alertView = SPAlertView(title: error.localizedDescription, preset: .error)
                alertView.dismissByTap = true
                alertView.present(duration: 5, haptic: .error, completion: nil)
                print("ERROR_LOG Error get image for url \(url): ", error.localizedDescription)
            }
        }
    }
    
    // MARK: - Handlers
    @objc private func shareAction() {
        guard let cell = fullscreenImagesCollectionView.visibleCells.first, let image = (cell as? ZommablePhotoCell)?.image else {
            print("ERROR_LOG Error get image in share action")
            let errorAlert = SPAlertView(title: NSLocalizedString(LocalizedStringKeys.kErrorGetImageForShare, comment: "Ошибка получения изображения"), preset: .error)
            errorAlert.dismissByTap = true
            errorAlert.present(duration: 5, haptic: .error, completion: nil)
            return
        }

        let items = [image]
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, success, items, error in
            if let error = error {
                let alertView = SPAlertView(title: error.localizedDescription, preset: .error)
                alertView.dismissByTap = true
                alertView.present(duration: 5, haptic: .error, completion: nil)
                return
            }
            
            if let _ = activity {
                SPAlert.present(title: NSLocalizedString(LocalizedStringKeys.kDone, comment: "Готово"), preset: .done)
            }
        }
        
        present(activityController, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FullscreenPhotosVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let photo = images[indexPath.row].sizes.last else {
            print("ERROR_LOG Error get photo for index path \(indexPath)")
            return UICollectionViewCell()
        }
        
        let imageUrl = photo.url
        let imageSize = CGSize(width: photo.width, height: photo.height)
        
        if collectionView == fullscreenImagesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZommablePhotoCell.reuseIdentifier, for: indexPath as IndexPath) as? ZommablePhotoCell
            else {
                print("ERROR_LOG Error get ZommablePhotoCell for index path \(indexPath)")
                return UICollectionViewCell()
            }
            
            setImageFor(imageScrollView: cell.imageScrollView, url: imageUrl)
            
            // Syncronize two collection view logic
            var index = indexPath.row
            if abs(prevIndex - indexPath.row) == 3 {
                if prevIndex - indexPath.row == -3 {
                    index -= 1
                } else {
                    index += 1
                }
            } else if abs(prevIndex - indexPath.row) == 2 {
                index -= 1
            } else {
                if prevIndex - indexPath.row == -1 {
                    index -= 1
                } else {
                    index += 1
                }
            }
            
            smallImagesCollectionView.scrollToItem(at: [indexPath.section, index], at: .centeredHorizontally, animated: true)
            prevIndex = indexPath.row
            
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath as IndexPath) as? PhotoCell
        else {
            print("ERROR_LOG Error get PhotoCell for index path \(indexPath)")
            return UICollectionViewCell()
        }
    
        cell.imageView.setImage(imageUrl: imageUrl, size: imageSize)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == smallImagesCollectionView else { return }
        
        let image = images[indexPath.row]
        guard selectedImage.id != image.id else {
            print("Is already selected")
            return
        }

        selectedImage = image
        
        generator.prepare()
        generator.impactOccurred()
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        fullscreenImagesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        setTitleWith(timeInterval: image.date)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let visibleCellIndexPath = fullscreenImagesCollectionView.indexPathsForVisibleItems.last {
            let visibleImage = images[visibleCellIndexPath.row]
            selectedImage = visibleImage
            setTitleWith(timeInterval: visibleImage.date)
        } else {
            print("ERROR_LOG No visible items in fullscreenImagesCollectionView")
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FullscreenPhotosVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
                
        if collectionView == fullscreenImagesCollectionView {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
}
