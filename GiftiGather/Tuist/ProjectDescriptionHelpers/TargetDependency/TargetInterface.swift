//
//  GroupInterface.swift
//  ProjectDescriptionHelpers
//
//  Created by minryul on 2023/03/18.
//

import ProjectDescription

public protocol TargetInterface {
    var groupName: String { get }
    var name: String { get }
}

public extension TargetInterface {
    var dependency: TargetDependency {
        let groupName = self.groupName.isEmpty ? "" : "\(self.groupName)/"
        
        return .project(
            target: self.name,
            path: .relativeToRoot("Targets/\(groupName)\(self.name)")
        )
    }
}
