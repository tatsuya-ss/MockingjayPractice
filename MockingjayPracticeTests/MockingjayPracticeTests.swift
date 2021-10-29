//
//  MockingjayPracticeTests.swift
//  MockingjayPracticeTests
//
//  Created by 坂本龍哉 on 2021/10/27.
//

import Mockingjay
import XCTest
@testable import MockingjayPractice

final class MockingjayPracticeTests: XCTestCase {
    
    func testFetchGitHubRepositoryFillName() {
        
        let client = GitHubAPIClient()
        
        // 返却するJSONデータ
        let body: [[String: Any]] = [
            [
                "id": 1,
                "name": "swift",
                "stargazers_count": 10
            ],
            [
                "id": 2,
                "name": "swift-evolution",
                "stargazers_count": 20
            ]
        ]
        
        // HTTPスタブの定義
        // "/users/apple/repos"にマッチするURLに対してリクエストされた際に、用意したJSONデータを返却するメソッド
        // stub関数は第一引数にMatcher、第二引数にBuilder
        // Matcherはどのリクエストにマッチさせるか
        // Builderは返却するレスポンスを生成
        stub(uri("/users/apple/repos"), json(body))
        
        let exp = expectation(description: "wait for complete api")
        
        // 関数の実行
        client.fetchRepositories(user: "apple") { repos in
            XCTAssertEqual(repos?.count, 2)
            XCTAssertEqual(repos?[0], GitHubRepository(id: 1,
                                                       star: 10,
                                                       name: "swift"))
            XCTAssertEqual(repos?[1], GitHubRepository(id: 2,
                                                       star: 20,
                                                       name: "swift-evolution"))
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3)
    }
    
}
