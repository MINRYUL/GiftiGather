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
}
