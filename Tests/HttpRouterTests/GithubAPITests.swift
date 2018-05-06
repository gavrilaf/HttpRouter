import XCTest
import HttpRouter
import HttpTestApi

class GithubAPITests: XCTestCase {
    
    var router: RoutesTree<String>!
    
    override func setUp() {
        router = RoutesTree<String>()
        
        for route in Github.api {
            try! router.add(method: HttpMethod(rawValue: route.0)!, url: URL(string: route.1)!, value: route.1)
        }
    }
    
    func testNonExisting() {
        XCTAssertNil(router.lookup(method: .get, url: URL(string: "/a/b/c")!))
        XCTAssertNil(router.lookup(method: .delete, url: URL(string: "/user/repos")!))
    }
    
    func testStatic() {
        XCTAssertEqual("/user/repos", router.lookup(method: .get, url: URL(string: "/user/repos")!)?.value)
        XCTAssertEqual("/user/repos", router.lookup(method: .post, url: URL(string: "/user/repos")!)?.value)
    }
    
    func testParams() {
        let r = router.lookup(method: .get, url: URL(string: "/repos/gavrilaf/httprouter/stargazers")!)
        
        XCTAssertNotNil(r)
        XCTAssertEqual(r?.value, "/repos/:owner/:repo/stargazers")
        XCTAssertEqual(r?.urlParams["owner"], "gavrilaf")
        XCTAssertEqual(r?.urlParams["repo"], "httprouter")
    }
    
    func testAllRoutes() {
        for route in Github.api {
            let method = HttpMethod(rawValue: route.0)!
            let path = route.1
            XCTAssertEqual(path, router.lookup(method: method, url: URL(string: path)!)?.value)
        }
    }
    
    static var allTests = [
        ("testNonExisting", testNonExisting),
        ("testStatic", testStatic),
        ("testParams", testParams),
        ("testAllRoutes", testAllRoutes),
    ]
}
