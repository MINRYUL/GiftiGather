//
//  DetailGiftiViewController.swift
//  GiftiGather
//
//  Created by 김민창 on 2023/03/01.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import UIKit

import DIContainer
import Presentation

final class DetailGiftiViewController: BaseViewController, DestinationTransitionViewController {
  
  var toView: UIView {
    return headerImageView
  }
  
  lazy var detailScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()
  
  lazy var contentView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemBackground
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    view.layer.cornerRadius = 20
    view.clipsToBounds = true
    return view
  }()
  
  lazy var headerImageView: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFill
    image.translatesAutoresizingMaskIntoConstraints = false
    image.clipsToBounds = true
    return image
  }()
  
  lazy var dismissButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
    button.tintColor = .darkGray
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  lazy var dummyView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  //MARK: - Injection
  @Injected private var _viewModel: DetailGiftiViewModel
  
  convenience init(giftiIdentifier: String) {
    self.init()
    
    self.headerImageView.setImage(with: giftiIdentifier, disposeBag: disposeBag)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.configureUI()
    
    self._configureTarget()
  }
  
  @objc private func _dismiss() {
    self.dismiss(animated: true)
  }
  
  private func _configureTarget() {
    self.dismissButton.addTarget(self, action: #selector(_dismiss), for: .touchUpInside)
    
    let panGesture = UIPanGestureRecognizer(
      target: self, action: #selector(panGestureRecognizerHandler(_:))
    )
    self.view.addGestureRecognizer(panGesture)
  }
  
  @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
    let translationY = sender.translation(in: sender.view ?? UIView()).y
    switch sender.state {
      case .began:  break
      case .changed: view.transform = CGAffineTransform(translationX: 0, y: translationY)
      case .ended, .cancelled:
        if translationY > 160 {
          dismiss(animated: true, completion: nil)
        } else {
          UIView.animate(withDuration: 0.2, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
          })
        }
      case .failed, .possible:
        break
      @unknown default:
        break
    }
  }
}
