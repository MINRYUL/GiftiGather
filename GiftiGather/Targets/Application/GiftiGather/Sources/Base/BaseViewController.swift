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
  
  func showToast(message: String) {
    let widthValue: CGFloat = 15
    
    let toastLabel = UILabel(
      frame: CGRect(
        x: widthValue,
        y: self.view.frame.size.height - 100,
        width: view.frame.size.width - 2 * widthValue,
        height: 50
      )
    )
    
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = .center
    toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    
    let _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
      UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveEaseOut, animations: {
        toastLabel.alpha = 0.0
      }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
      })
    }
  }
}
