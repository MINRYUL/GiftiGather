//
//  BaseView.swift
//  GiftiGather
//
//  Created by 김민창 on 2023/03/01.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import UIKit

class BaseView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.viewDidInit()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func viewDidInit() { }
}
