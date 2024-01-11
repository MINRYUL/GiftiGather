//
//  ViewModel.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

public protocol ViewModel {
  var disposeBag: DisposeBag { get set }
}
