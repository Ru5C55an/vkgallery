//
//  UIImageView + Extension.swift
//  vkgallery
//
//  Created by Руслан Садыков on 11.08.2021.
//

import Kingfisher
import UIKit

extension UIImageView {
    func setImage(imageUrl: URL, size: CGSize) {
        let processor = DownsamplingImageProcessor(size: size)
        var loadingIndicator = ImageIndicator()
        self.kf.indicatorType = .custom(indicator: loadingIndicator)
        self.kf.setImage(
            with: imageUrl,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
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
}

