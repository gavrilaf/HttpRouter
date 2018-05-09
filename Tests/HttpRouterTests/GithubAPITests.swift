import XCTest
import HttpRouter
import HttpTestApi

class GithubAPITests: XCTestCase {
    
    func testNonExisting() {
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            XCTAssertNil(router.lookup(method: .get, uri: "/a/b/c"))
            XCTAssertNil(router.lookup(method: .delete, uri: "/user/repos"))
        }
        
        testRouter(RouterDict<String>(), routes: Github.api, check: check)
        testRouter(RouterArray<String>(), routes: Github.api, check: check)
        testRouter(RouterSortedArray<String>(), routes: Github.api, check: check)
    }
    
    func testStatic() {
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            XCTAssertEqual("/user/repos", router.lookup(method: .get, uri: "/user/repos")?.value)
            XCTAssertEqual("/user/repos", router.lookup(method: .post, uri: "/user/repos")?.value)
        }
        
        testRouter(RouterDict<String>(), routes: Github.api, check: check)
        testRouter(RouterArray<String>(), routes: Github.api, check: check)
        testRouter(RouterSortedArray<String>(), routes: Github.api, check: check)
    }
    
    func testParams() {
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            let r = router.lookup(method: .get, uri: "/repos/gavrilaf/httprouter/stargazers")
            XCTAssertNotNil(r)
            XCTAssertEqual(r?.value, "/repos/:owner/:repo/stargazers")
            XCTAssertEqual(r?.urlParams["owner"], "gavrilaf")
            XCTAssertEqual(r?.urlParams["repo"], "httprouter")
        }
        
        testRouter(RouterDict<String>(), routes: Github.api, check: check)
        testRouter(RouterArray<String>(), routes: Github.api, check: check)
        testRouter(RouterSortedArray<String>(), routes: Github.api, check: check)
    }
    
    func testAllRoutes() {
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            for route in Github.api {
                let method = HttpMethod(rawValue: route.0)!
                let path = route.1
                XCTAssertEqual(path, router.lookup(method: method, uri: path)?.value)
            }
        }
        
        testRouter(RouterDict<String>(), routes: Github.api, check: check)
        testRouter(RouterArray<String>(), routes: Github.api, check: check)
        testRouter(RouterSortedArray<String>(), routes: Github.api, check: check)
    }
    
    static var allTests = [
        ("testNonExisting", testNonExisting),
        ("testStatic", testStatic),
        ("testParams", testParams),
        ("testAllRoutes", testAllRoutes),
    ]
}
