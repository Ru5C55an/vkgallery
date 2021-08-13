//
//  PhotoLoadingIndicator.swift
//  vkgallery
//
//  Created by Руслан Садыков on 11.08.2021.
//

import Kingfisher
import Lottie

enum ProgressKeyFrames: CGFloat {
    case start = 0
    case end = 55
}

struct ImageIndicator: Indicator {
    let view: UIView = UIView()
    
    let animationView: AnimationView = AnimationView(name: "ImageLoading")
    
    var percentage: CGFloat = 0 {
        didSet {
            progress(to: percentage)
        }
    }
    
    private func progress(to progress: CGFloat) {
        let progressRange = ProgressKeyFrames.end.rawValue - ProgressKeyFrames.start.rawValue
        let progressFrame = progressRange * progress
        let currentFrame = progressFrame + ProgressKeyFrames.start.rawValue
        animationView.currentProgress = currentFrame
    }
    
    func startAnimatingView() {
        view.isHidden = false
        animationView.animationSpeed = 0.5
        animationView.currentFrame = ProgressKeyFrames.end.rawValue
        animationView.play(fromFrame: ProgressKeyFrames.start.rawValue, toFrame: ProgressKeyFrames.end.rawValue, loopMode: .none)
    }
    
    func stopAnimatingView() {
        animationView.stop()
        view.isHidden = true
    }
    
    init() {
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
