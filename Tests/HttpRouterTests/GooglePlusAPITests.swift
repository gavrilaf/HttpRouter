import XCTest
import HttpRouter
import HttpTestApi

class GooglePlusAPITests: XCTestCase {
    
    func testRoutes() {
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            checkRoute(router, .get, "/people", "/people")
            checkRoute(router, .get, "/activities", "/activities")
            
            checkRoute(router, .get, "/people/user-1", "/people/:userId", ["userId": "user-1"])
            checkRoute(router, .get, "/activities/activity-1/people/collection-1", "/activities/:activityId/people/:collection", ["activityId": "activity-1", "collection": "collection-1"])
            checkRoute(router, .post, "/people/user-1/moments/collection-2", "/people/:userId/moments/:collection", ["userId": "user-1", "collection": "collection-2"])
        }
        
        testRouter(RouterDict<String>(), routes: GooglePlus.api, check: check)
        testRouter(RouterArray<String>(), routes: GooglePlus.api, check: check)
        testRouter(RouterSortedArray<String>(), routes: GooglePlus.api, check: check)
    }
    
    func testNonExisting() {
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            XCTAssertNil(router.lookup(method: .get, uri: "/a/b/c"))
            XCTAssertNil(router.lookup(method: .post, uri: "/activities"))
            XCTAssertNil(router.lookup(method: .put, uri: "/people/user-1/moments/collection-2"))
        }
        
        testRouter(RouterDict<String>(), routes: GooglePlus.api, check: check)
        testRouter(RouterArray<String>(), routes: GooglePlus.api, check: check)
        testRouter(RouterSortedArray<String>(), routes: GooglePlus.api, check: check)
    }
    
    func testAllRoutes() {
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            for route in GooglePlus.api {
                let method = HttpMethod(rawValue: route.0)!
                let path = route.1
                checkRoute(router, method, path, path)
            }
        }
        
        testRouter(RouterDict<String>(), routes: GooglePlus.api, check: check)
        testRouter(RouterArray<String>(), routes: GooglePlus.api, check: check)
        testRouter(RouterSortedArray<String>(), routes: GooglePlus.api, check: check)
    }
    
    static var allTests = [
        ("testNonExisting", testNonExisting),
        ("testRoutes", testRoutes),
        ("testAllRoutes", testAllRoutes),
    ]
}
