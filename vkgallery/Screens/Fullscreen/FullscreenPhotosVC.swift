//
//  FullscreenPhotosVC.swift
//  vkgallery
//
//  Created by Руслан Садыков on 11.08.2021.
//

import UIKit
import Kingfisher

final class FullscreenPhotosVC: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let itemSpacing: CGFloat = 2
    }
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
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
    
    private let imageScrollView = ImageScrollView()
    
    // MARK: - Haptic feedback
    private let generator = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: - Properties
    private let images: [PhotoModel]
    private var selectedImage: PhotoModel
    
    // MARK: - Init
    init(images: [PhotoModel], selectedImage: PhotoModel) {
        self.images = images
        self.selectedImage = selectedImage
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

        let image = selectedImage.sizes.last!
        setImageFor(url: image.url)
    }
    
    // MARK: - setupNavBar
    private func setupNavBar() {
        setTitleWith(timeInterval: selectedImage.date)
        navigationController?.navigationBar.standardAppearance.shadowColor = .lightGray
        
        let shareImage = UIImage(named: "share")?.withTintColor(.primaryColor, renderingMode: .alwaysOriginal)
        let shareBarButtonItem = UIBarButtonItem(image: shareImage, style: .plain, target: self, action: #selector(shareAction))
        navigationItem.rightBarButtonItem = shareBarButtonItem
    }
    
    // MARK: - Setup views
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(imageScrollView)
        view.addSubview(collectionView)
    }
    
    // MARK: - Setup constraints
    private func setupConstraints() {
        imageScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(collectionView.snp.top)
        }
        
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: - Functions
    private func setTitleWith(timeInterval: TimeInterval) {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateString = DateFormatter.ddMMMMyyyy.string(from: date)
        navigationItem.title = dateString
    }
    
    private func setImageFor(url: URL) {
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            
            case .success(let retrieveImageResult):
                self.imageScrollView.set(image: retrieveImageResult.image)
            case .failure(let error):
                print("ERROR_LOG Error get image for url \(url): ", error.localizedDescription)
            }
        }
    }
    
    
    // MARK: - Handlers
    @objc private func shareAction() {
        guard let image = imageScrollView.imageZoomView.image else {
            print("ERROR_LOG Error get image from image scroll view")
            return
        }
        
        let items = [image]
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityController.completionWithItemsHandler = { [weak self] activity, success, items, error in
            if let error = error {
                self?.showAlertWith(title: error.localizedDescription, message: nil)
                return
            }
            
            if let activity = activity {
                self?.showAlertWith(title: NSLocalizedString(LocalizedStringKeys.kDone, comment: "Готово"), message: nil)
            }
        }
        
        present(activityController, animated: true)
    }
    
    private func showAlertWith(title: String, message: String?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath as IndexPath) as? PhotoCell
        else {
            print("ERROR_LOG Error get PhotoCell for index path \(indexPath)")
            return UICollectionViewCell() }
        guard let photo = images[indexPath.row].sizes.last else {
            print("ERROR_LOG Error get photo for index path \(indexPath)")
            return UICollectionViewCell()
        }
        
        let imageUrl = photo.url
        let imageSize = CGSize(width: photo.width, height: photo.height)
        cell.imageView.setImage(imageUrl: imageUrl, size: imageSize)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = images[indexPath.row]
        guard let imageSize = image.sizes.last else {
            print("ERROR_LOG Error get image for indexPath \(indexPath)")
            return
        }
        generator.prepare()
        generator.impactOccurred()
        
        setImageFor(url: imageSize.url)
        setTitleWith(timeInterval: image.date)
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
                
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
}
