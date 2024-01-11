//
//  Application.swift
//  ProjectDescriptionHelpers
//
//  Created by minryul on 2023/03/18.
//

import Foundation

public enum Application: String, TargetInterface {
    case GiftiGather
    case Presentation
    
    public var groupName: String {
        return "Application"
    }
    
    public var name: String {
        return self.rawValue
    }
}
