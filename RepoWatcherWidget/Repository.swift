//
//  Repository.swift
//  RepoWatcher
//
//  Created by Nicolas Rios on 10/25/22.
//

import Foundation

struct Respository: Decodable {
    let name: String
    let owner: Owner
    let forks: Int
    let watchers: Int
    let hasIssues: Bool
    let openIssues: Int
    let pushedAt: String
    
    static let placeholder = Respository(name: "your repo",
                                         owner: Owner(avatarUrl: ""),
                                         forks: 69,
                                         watchers: 123,
                                         hasIssues: true,
                                         openIssues: 55,
                                         pushedAt: "2022-08-09T18:19:30z")
                                        
}

struct Owner: Decodable {
    let avatarUrl: String
    
}
