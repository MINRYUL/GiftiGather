//
//  PresentAnimator.swift
//  GiftiGather
//
//  Created by 김민창 on 2023/03/10.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import UIKit

final class PresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  weak var presenting: SourceTransitionViewController?
  weak var presented: DestinationTransitionViewController?
  let duration: TimeInterval
  
  init(
    presenting: SourceTransitionViewController,
    presented: DestinationTransitionViewController,
    duration: TimeInterval
  ) {
    self.presenting = presenting
    self.presented = presented
    self.duration = duration
  }
  
  func asImage(from targetView: UIView) -> UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: targetView.bounds)
    return renderer.image { rendererContext in
      targetView.layer.render(in: rendererContext.cgContext)
    }
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func getSafeAreaTop() -> CGFloat {
    let keyWindow = UIApplication.shared.connectedScenes
      .filter { $0.activationState == .foregroundActive }
      .map { $0 as? UIWindowScene }
      .compactMap{ $0 }
      .first?.windows
      .filter { $0.isKeyWindow }.first
    return keyWindow?.safeAreaInsets.top ?? 0
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let presenting = presenting, let presented = presented else {
      transitionContext.cancelInteractiveTransition()
      return
    }
    
    let containerView = transitionContext.containerView
    presented.view.frame = transitionContext.finalFrame(for: presented)
    presented.view.layoutIfNeeded()
    containerView.addSubview(presented.view)
    presented.view.alpha = 0
    
    let transitionableView = presenting.fromView
    
    let animationView = UIView(frame: presenting.view.frame)
    animationView.backgroundColor = .clear
    let imageView = UIImageView(
      frame: transitionableView.superview!.convert(
        transitionableView.frame,
        to: animationView
      )
    )
    imageView.image = self.asImage(from: transitionableView)
    imageView.contentMode = transitionableView.contentMode
    animationView.addSubview(imageView)
    containerView.addSubview(animationView)
    
    let animation = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.8) {
      let toViewFrame = CGRect(
        origin: CGPoint(
          x: presented.toView.frame.origin.x,
          y: presented.toView.frame.origin.y + self.getSafeAreaTop()
        ), size: presented.toView.frame.size
      )
      imageView.frame = toViewFrame
    }
    animation.addCompletion { (_) in
      presented.view.alpha = 1
      animationView.removeFromSuperview()
      transitionContext.completeTransition(true)
    }
    animation.startAnimation()
  }
}
