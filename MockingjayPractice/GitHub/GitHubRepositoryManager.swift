//
//  GitHubRepositoryManager.swift
//  MockingjayPractice
//
//  Created by 坂本龍哉 on 2021/10/27.
//

import Foundation

final class GitHubRepositoryManager {
    private let client: GitHubAPIClientProtocol
    private var repos: [GitHubRepository]?
    
    var majorRepositories: [GitHubRepository] {
        guard let repositories = self.repos else { return [] }
        return repositories.filter { $0.star >= 10 }
    }
    
    init(client: GitHubAPIClientProtocol = GitHubAPIClient()) {
        self.client = client
    }
    
    func load(user: String, completion: @escaping () -> Void) {
        self.client.fetchRepositories(user: user) { repositories in
            self.repos = repositories
            completion()
        }
    }
}
