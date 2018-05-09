import XCTest
import HttpRouter
import HttpTestApi

class GooglePlusAPITests: XCTestCase {
    
    func testNonExisting() {
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            XCTAssertNil(router.lookup(method: .get, uri: "/a/b/c"))
            XCTAssertNil(router.lookup(method: .delete, uri: "/people"))
        }
        
        testRouter(RouterDict<String>(), routes: GooglePlus.api, check: check)
        testRouter(RouterArray<String>(), routes: GooglePlus.api, check: check)
        testRouter(RouterSortedArray<String>(), routes: GooglePlus.api, check: check)
    }
    
    func testStatic() {
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            XCTAssertEqual("/people", router.lookup(method: .get, uri: "/people")?.value)
            XCTAssertEqual("/activities", router.lookup(method: .get, uri: "/activities")?.value)
        }
        
        testRouter(RouterDict<String>(), routes: GooglePlus.api, check: check)
        testRouter(RouterArray<String>(), routes: GooglePlus.api, check: check)
        testRouter(RouterSortedArray<String>(), routes: GooglePlus.api, check: check)
    }
    
    func testParams() {
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            let r = router.lookup(method: .post, uri: "/people/gavrilaf/moments/photos")
            XCTAssertNotNil(r)
            XCTAssertEqual(r?.value, "/people/:userId/moments/:collection")
            XCTAssertEqual(r?.urlParams["userId"], "gavrilaf")
            XCTAssertEqual(r?.urlParams["collection"], "photos")
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
                XCTAssertEqual(path, router.lookup(method: method, uri: path)?.value)
            }
        }
        
        testRouter(RouterDict<String>(), routes: GooglePlus.api, check: check)
        testRouter(RouterArray<String>(), routes: GooglePlus.api, check: check)
        testRouter(RouterSortedArray<String>(), routes: GooglePlus.api, check: check)
    }

    static var allTests = [
        ("testNonExisting", testNonExisting),
        ("testStatic", testStatic),
        ("testParams", testParams),
        ("testAllRoutes", testAllRoutes),
    ]
}
