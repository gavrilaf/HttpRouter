import XCTest
import HttpRouter
import HttpTestApi

class GithubAPITests: XCTestCase {
    
    func testRoutes() {
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            checkRoute(router, .post, "/authorizations", "/authorizations")
            checkRoute(router, .get, "/feeds", "/feeds")
            
            checkRoute(router, .put, "/notifications/threads/100/subscription", "/notifications/threads/:id/subscription", ["id": "100"])
            checkRoute(router, .get, "/repos/owner-1/repo-1/git/tags/sha512", "/repos/:owner/:repo/git/tags/:sha", ["owner": "owner-1", "repo": "repo-1", "sha": "sha512"])
        }
        
        testRouter(RouterDict<String>(), routes: Github.api, check: check)
        testRouter(RouterArray<String>(), routes: Github.api, check: check)
        testRouter(RouterSortedArray<String>(), routes: Github.api, check: check)
        
        testRouter(Router2<NodesDictionary, String>(), routes: Github.api, check: check)
    }
    
    func testNonExisting() {
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            XCTAssertNil(router.lookup(method: .get, uri: "/a/b/c"))
            XCTAssertNil(router.lookup(method: .post, uri: "/feeds"))
            XCTAssertNil(router.lookup(method: .post, uri: "/notifications/threads/100/subscription"))
        }
        
        testRouter(RouterDict<String>(), routes: Github.api, check: check)
        testRouter(RouterArray<String>(), routes: Github.api, check: check)
        testRouter(RouterSortedArray<String>(), routes: Github.api, check: check)
        
        testRouter(Router2<NodesDictionary, String>(), routes: Github.api, check: check)
    }
    
    func testAllRoutes() {
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            for route in Github.api {
                let method = HttpMethod(rawValue: route.0)!
                let path = route.1
                checkRoute(router, method, path, path)
            }
        }
        
        testRouter(RouterDict<String>(), routes: Github.api, check: check)
        testRouter(RouterArray<String>(), routes: Github.api, check: check)
        testRouter(RouterSortedArray<String>(), routes: Github.api, check: check)
        
        testRouter(Router2<NodesDictionary, String>(), routes: Github.api, check: check)
    }
    
    static var allTests = [
        ("testNonExisting", testNonExisting),
        ("testRoutes", testRoutes),
        ("testAllRoutes", testAllRoutes),
    ]
}
