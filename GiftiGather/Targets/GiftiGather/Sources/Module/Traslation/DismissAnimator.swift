//
//  DismissAnimator.swift
//  GiftiGather
//
//  Created by 김민창 on 2023/03/10.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import UIKit

final class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
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
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let presenting = presenting, let presented = presented else {
      transitionContext.cancelInteractiveTransition()
      return
    }
    
    let containerView = transitionContext.containerView
    let animationView = UIView(frame: presented.view.frame)
    containerView.addSubview(presenting.view)
    
    let backgroundView = UIView(frame: animationView.frame)
    backgroundView.backgroundColor = .white
    animationView.addSubview(backgroundView)
    
    let imageView = UIImageView(image: asImage(from: presented.toView))
    imageView.contentMode = presented.toView.contentMode
    imageView.frame = presented.toView.frame
    animationView.addSubview(imageView)
    containerView.addSubview(animationView)
    
    let transitionableView = presenting.fromView
    
    let destinationFrame = transitionableView.superview!.convert(
      transitionableView.frame, to: containerView
    )
    let cellBackgroundView = UIView(frame: destinationFrame)
    cellBackgroundView.backgroundColor = .white
    containerView.insertSubview(cellBackgroundView, aboveSubview: presenting.view)
    
    UIView.animate(withDuration: duration, animations: {
      backgroundView.alpha = 0
      imageView.frame = destinationFrame
    }) { (_) in
      cellBackgroundView.removeFromSuperview()
      animationView.removeFromSuperview()
      transitionContext.completeTransition(true)
    }
  }
}
