import XCTest
@testable import HttpRouterTests

XCTMain([
    testCase(RoutesTreeTests.allTests),
    testCase(GithubAPITests.allTests),
])
