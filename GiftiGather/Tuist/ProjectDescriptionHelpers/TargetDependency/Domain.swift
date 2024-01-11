//
//  Domain.swift
//  ProjectDescriptionHelpers
//
//  Created by minryul on 2023/04/09.
//

import Foundation

public enum Domain: String, TargetInterface {
    case Domain
    
    public var groupName: String {
        return ""
    }
    
    public var name: String {
        return self.rawValue
    }
}
