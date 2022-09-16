//
//  String+Extension.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    func localized(with argument: CVarArg = [], comment: String = "") -> String {
        return String(format: self.localized(comment: comment), argument)
    }
}
