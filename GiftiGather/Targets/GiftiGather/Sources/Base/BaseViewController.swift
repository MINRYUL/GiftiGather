//
//  BaseViewController.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/07.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    static func instantiate(
    ) -> BaseViewController? {
        return Self()
    }
}
