//
//  Data.swift
//  ProjectDescriptionHelpers
//
//  Created by minryul on 2023/04/09.
//

import Foundation

public enum Data: String, TargetInterface {
    case Repository
    
    public var groupName: String {
        return "Data"
    }
    
    public var name: String {
        return self.rawValue
    }
}
