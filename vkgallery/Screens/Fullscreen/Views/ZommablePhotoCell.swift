//
//  ZommablePhotoCell.swift
//  vkgallery
//
//  Created by Руслан Садыков on 13.08.2021.
//

import UIKit

class ZommablePhotoCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    let imageScrollView = ImageScrollView()
    
    // MARK: - Properties
    var image: UIImage? {  return imageScrollView.imageZoomView.image }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup views
    private func setupViews() {
        addSubview(imageScrollView)
    }
    
    // MARK: - Setup constraints
    private func setupConstraints() {
        imageScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
