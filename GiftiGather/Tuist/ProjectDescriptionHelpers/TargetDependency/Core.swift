//
//  Core.swift
//  ProjectDescriptionHelpers
//
//  Created by minryul on 2023/03/18.
//

import Foundation

public enum Core: String, TargetInterface {
    case Core
    
    public var groupName: String {
        return ""
    }
    
    public var name: String {
        return self.rawValue
    }
}
