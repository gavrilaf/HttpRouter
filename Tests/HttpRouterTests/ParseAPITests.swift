import XCTest
import HttpRouter
import HttpTestApi

class ParseAPITests: XCTestCase {
    
    func testRoutes() {
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            checkRoute(router, .post, "/1/users", "/1/users")
            checkRoute(router, .get, "/1/login", "/1/login")
            checkRoute(router, .get, "/1/roles", "/1/roles")
            checkRoute(router, .post, "/1/roles", "/1/roles")
            
            checkRoute(router, .post, "/1/classes/class-name-1", "/1/classes/:className", ["className": "class-name-1"])
            checkRoute(router, .put, "/1/classes/class-name-1/object-2", "/1/classes/:className/:objectId", ["className": "class-name-1", "objectId": "object-2"])
            checkRoute(router, .get, "/1/classes/class-name-1/object-2", "/1/classes/:className/:objectId", ["className": "class-name-1", "objectId": "object-2"])
            checkRoute(router, .delete, "/1/classes/class-name-1/object-3", "/1/classes/:className/:objectId", ["className": "class-name-1", "objectId": "object-3"])
        }
        
        testRouter(RouterDict<String>(), routes: Parse.api, check: check)
        testRouter(RouterArray<String>(), routes: Parse.api, check: check)
        testRouter(RouterSortedArray<String>(), routes: Parse.api, check: check)
    }
    
    func testNonExisting() {
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            XCTAssertNil(router.lookup(method: .get, uri: "/a/b/c"))
            XCTAssertNil(router.lookup(method: .put, uri: "/1/users"))
            XCTAssertNil(router.lookup(method: .post, uri: "/1/login"))
            XCTAssertNil(router.lookup(method: .post, uri: "/1/classes/class-name-1/object-2"))
        }
        
        testRouter(RouterDict<String>(), routes: Parse.api, check: check)
        testRouter(RouterArray<String>(), routes: Parse.api, check: check)
        testRouter(RouterSortedArray<String>(), routes: Parse.api, check: check)
    }
    
    func testAllRoutes() {
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            for route in Parse.api {
                let method = HttpMethod(rawValue: route.0)!
                let path = route.1
                checkRoute(router, method, path, path)
            }
        }
        
        testRouter(RouterDict<String>(), routes: Parse.api, check: check)
        testRouter(RouterArray<String>(), routes: Parse.api, check: check)
        testRouter(RouterSortedArray<String>(), routes: Parse.api, check: check)
    }
    
    static var allTests = [
        ("testNonExisting", testNonExisting),
        ("testRoutes", testRoutes),
        ("testAllRoutes", testAllRoutes),
    ]
}
