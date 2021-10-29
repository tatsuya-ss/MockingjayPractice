//
//  GitHubAPIClient.swift
//  MockingjayPractice
//
//  Created by 坂本龍哉 on 2021/10/27.
//

import Foundation

protocol GitHubAPIClientProtocol {
    func fetchRepositories(user: String,
                           handler: @escaping ([GitHubRepository]?) -> Void)
}

final class GitHubAPIClient: GitHubAPIClientProtocol {
    // ユーザ名を受け取り、そのユーザのリポジトリ一覧を取得する。
    func fetchRepositories(user: String,
                           handler: @escaping ([GitHubRepository]?) -> Void) {
        let url = URL(string: "https://api.github.com/users/\(user)/repos")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                handler(nil)
                return
            }
            let repos = try! JSONDecoder().decode([GitHubRepository].self,
                                                  from: data)
            DispatchQueue.main.async {
                handler(repos)
            }
        }
        task.resume()
    }
    
}
