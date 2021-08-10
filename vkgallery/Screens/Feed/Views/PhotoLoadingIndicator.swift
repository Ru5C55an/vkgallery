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

      // 1. We get the range of frames specific for the progress from 0-100%
      
      let progressRange = ProgressKeyFrames.end.rawValue - ProgressKeyFrames.start.rawValue
      
      // 2. Then, we get the exact frame for the current progress
      
      let progressFrame = progressRange * progress
      
      // 3. Then we add the start frame to the progress frame
      // Considering the example that we start in 140, and we moved 30 frames in the progress, we should show frame 170 (140+30)
      
      let currentFrame = progressFrame + ProgressKeyFrames.start.rawValue
      
      // 4. Manually setting the current animation frame
      
        animationView.currentProgress = currentFrame
    }
    
    func startAnimatingView() {
        view.isHidden = false
        animationView.animationSpeed = 0.5
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
