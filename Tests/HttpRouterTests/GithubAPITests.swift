import XCTest
import HttpRouter
import HttpTestApi

class GithubAPITests: XCTestCase {
    
    func testNonExisting() {
        let testBlock: TestBlock = { (router) in
            XCTAssertNil(router.lookup(method: .get, url: URL(string: "/a/b/c")!))
            XCTAssertNil(router.lookup(method: .delete, url: URL(string: "/user/repos")!))
        }
        
        testRouterS(RouterDict<String>(), routes: Github.api, testBlock: testBlock)
    }
    
    func testStatic() {
        let testBlock: TestBlock = { (router) in
            XCTAssertEqual("/user/repos", router.lookup(method: .get, url: URL(string: "/user/repos")!)?.value)
            XCTAssertEqual("/user/repos", router.lookup(method: .post, url: URL(string: "/user/repos")!)?.value)
        }
        
        testRouterS(RouterDict<String>(), routes: Github.api, testBlock: testBlock)
    }
    
    func testParams() {
        let testBlock: TestBlock = { (router) in
            let r = router.lookup(method: .get, url: URL(string: "/repos/gavrilaf/httprouter/stargazers")!)
            XCTAssertNotNil(r)
            XCTAssertEqual(r?.value, "/repos/:owner/:repo/stargazers")
            XCTAssertEqual(r?.urlParams["owner"], "gavrilaf")
            XCTAssertEqual(r?.urlParams["repo"], "httprouter")
        }
        
        testRouterS(RouterDict<String>(), routes: Github.api, testBlock: testBlock)
    }
    
    func testAllRoutes() {
        let testBlock: TestBlock = { (router) in
            for route in Github.api {
                let method = HttpMethod(rawValue: route.0)!
                let path = route.1
                XCTAssertEqual(path, router.lookup(method: method, url: URL(string: path)!)?.value)
            }
        }
        
        testRouterS(RouterDict<String>(), routes: Github.api, testBlock: testBlock)
    }
    
    static var allTests = [
        ("testNonExisting", testNonExisting),
        ("testStatic", testStatic),
        ("testParams", testParams),
        ("testAllRoutes", testAllRoutes),
    ]
}
