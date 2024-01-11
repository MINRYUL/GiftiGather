//
//  DIContainer.swift
//  ProjectDescriptionHelpers
//
//  Created by minryul on 2023/04/09.
//

import Foundation

public enum DIContainer: String, TargetInterface {
    case DIContainer
    
    public var groupName: String {
        return ""
    }
    
    public var name: String {
        return self.rawValue
    }
}
