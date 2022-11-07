//
//  MockData.swift
//  RepoWatcherWidgetExtension
//
//  Created by Nicolas Rios on 11/6/22.
//

import Foundation

struct MockData {
    static let RepoOne = Repository(name: "Repository1",
                                    owner: Owner(avatarUrl: ""),
                                    hasIssues: true,
                                    forks: 65,
                                    watchers: 123,
                                    openIssues: 55,
                                    pushedAt: "2022-07-09T18:19:30Z",
                                    avatarData: Data())
    
    static let RepoTwo = Repository(name: "Repository2",
                                    owner: Owner(avatarUrl: ""),
                                    hasIssues: false,
                                    forks: 134,
                                    watchers: 964,
                                    openIssues: 120,
                                    pushedAt: "2022-07-09T18:19:30Z",
                                    avatarData: Data())
    
}
