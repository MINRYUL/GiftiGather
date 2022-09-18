//
//  BaseViewController.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/07.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import UIKit

import RxSwift

class BaseViewController: UIViewController {
  var disposeBag: DisposeBag = DisposeBag()
  
  static func instantiate(
  ) -> BaseViewController? {
    return Self()
  }
  
  deinit {
    print("\(Self.className) is deinit 😇")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func showToast(_ message: String) {
    let toastLabel = UILabel(
      frame: CGRect(
        x: self.view.frame.size.width/2 - 75,
        y: self.view.frame.size.height-100,
        width: 150,
        height: 35
      )
    )
    
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    toastLabel.textColor = UIColor.white
    toastLabel.font = UIFont.systemFont(ofSize: 14.0)
    toastLabel.textAlignment = .center
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 16
    toastLabel.clipsToBounds  =  true
    
    self.view.addSubview(toastLabel)
    
    UIView.animate(withDuration: 2.5, delay: 0.5, options: .curveEaseOut, animations: {
      toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
      toastLabel.removeFromSuperview()
    })
  }
}
