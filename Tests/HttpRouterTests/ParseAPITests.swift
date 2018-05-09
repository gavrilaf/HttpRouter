import XCTest
import HttpRouter
import HttpTestApi

class ParseAPITests: XCTestCase {
    
    func testNonExisting() {
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            XCTAssertNil(router.lookup(method: .get, uri: "/a/b/c"))
            XCTAssertNil(router.lookup(method: .delete, uri: "/user/repos"))
        }
        
        testRouter(RouterDict<String>(), routes: Parse.api, check: check)
        testRouter(RouterArray<String>(), routes: Parse.api, check: check)
        testRouter(RouterSortedArray<String>(), routes: Parse.api, check: check)
    }
    
    func testStatic() {
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            XCTAssertEqual("/1/users", router.lookup(method: .get, uri: "/1/users")?.value)
            XCTAssertEqual("/1/users", router.lookup(method: .post, uri: "/1/users")?.value)
        }
        
        testRouter(RouterDict<String>(), routes: Parse.api, check: check)
        testRouter(RouterArray<String>(), routes: Parse.api, check: check)
        testRouter(RouterSortedArray<String>(), routes: Parse.api, check: check)
    }
    
    func testParams() {
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            let r1 = router.lookup(method: .get, uri: "/1/classes/swift")
            XCTAssertNotNil(r1)
            XCTAssertEqual(r1?.value, "/1/classes/:className")
            XCTAssertEqual(r1?.urlParams["className"], "swift")
            
            let r2 = router.lookup(method: .get, uri: "/1/classes/swift/123456789")
            XCTAssertNotNil(r2)
            XCTAssertEqual(r2?.value, "/1/classes/:className/:objectId")
            XCTAssertEqual(r2?.urlParams["className"], "swift")
            XCTAssertEqual(r2?.urlParams["objectId"], "123456789")
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
                XCTAssertEqual(path, router.lookup(method: method, uri: path)?.value)
            }
        }
        
        testRouter(RouterDict<String>(), routes: Parse.api, check: check)
        testRouter(RouterArray<String>(), routes: Parse.api, check: check)
        testRouter(RouterSortedArray<String>(), routes: Parse.api, check: check)
    }
    
    static var allTests = [
        ("testNonExisting", testNonExisting),
        ("testStatic", testStatic),
        ("testParams", testParams),
        ("testAllRoutes", testAllRoutes),
    ]
}
