import XCTest
import HttpRouter

class RouterBasicTests: XCTestCase {
    
    func testSimpleRoutes() {
        let routes = [
            ("GET", "/"),
            ("POST", "/a"),
            ("DELETE", "/b/"),
            ("PUT", "/c/d"),
            ("GET", "/public/tickers"),
            ("PUT", "/auth/register"),
            ("POST", "/auth/login"),
        ]
        
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            for r in routes {
                XCTAssertEqual(r.1, router.lookup(method: HttpMethod(rawValue: r.0)!, uri: r.1)?.value)
            }
        }
        
        testRouter(RouterDict<String>(), routes: routes, check: check)
        testRouter(RouterArray<String>(), routes: routes, check: check)
        testRouter(RouterSortedArray<String>(), routes: routes, check: check)
    }
    
    func testParams() {
        let routes = [
            ("GET", "/:id"),
            ("GET", "/:id/:name"),
            ("GET", "/:id/vasya"),
            ("GET", "/auth/session/:id"),
        ]
        
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            let r1 = router.lookup(method: .get, uri: "/id123")
            XCTAssertNotNil(r1)
            XCTAssertEqual(r1?.value, "/:id")
            XCTAssertNotNil(r1?.urlParams["id"], "id123")
            
            let r2 = router.lookup(method: .get, uri: "/id456/john")
            XCTAssertNotNil(r2)
            XCTAssertEqual(r2?.value, "/:id/:name")
            XCTAssertEqual(r2?.urlParams.count, 2)
            XCTAssertEqual(r2?.urlParams["id"], "id456")
            XCTAssertEqual(r2?.urlParams["name"], "john")
            
            let r3 = router.lookup(method: .get, uri: "/id789/vasya")
            XCTAssertNotNil(r3)
            XCTAssertEqual(r3?.value, "/:id/vasya")
            XCTAssertEqual(r3?.urlParams.count, 1)
            XCTAssertEqual(r3?.urlParams["id"], "id789")
            
            let r4 = router.lookup(method: .get, uri: "/auth/session/2")
            XCTAssertNotNil(r4)
            XCTAssertEqual(r4?.value, "/auth/session/:id")
            XCTAssertEqual(r4?.urlParams["id"], "2")
        }
        
        testRouter(RouterDict<String>(), routes: routes, check: check)
        testRouter(RouterArray<String>(), routes: routes, check: check)
        testRouter(RouterSortedArray<String>(), routes: routes, check: check)
    }
    
    func testNonExistingRoutes() {
        let routes = [
            ("GET", "/1/:id"),
        ]
        
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            XCTAssertNil(router.lookup(method: .get, uri: "/2/vasya"))
            XCTAssertNil(router.lookup(method: .post, uri: "/1/vasya"))
            XCTAssertNil(router.lookup(method: .delete, uri: "/1/"))
        }
        
        testRouter(RouterDict<String>(), routes: routes, check: check)
        testRouter(RouterArray<String>(), routes: routes, check: check)
        testRouter(RouterSortedArray<String>(), routes: routes, check: check)
    }

    
    func testMethods() {
        let routes = [
            ("GET", "/get"),
            ("POST", "/post"),
            ("PUT", "/put"),
            ("DELETE", "/delete"),
        ]
        
        func check<T: RouterProtocol>(router: T) where T.StoredValue == String {
            XCTAssertEqual(router.lookup(method: .get, uri: "/get")?.value, "/get")
            XCTAssertEqual(router.lookup(method: .post, uri: "/post")?.value, "/post")
            XCTAssertEqual(router.lookup(method: .put, uri: "/put")?.value, "/put")
            XCTAssertEqual(router.lookup(method: .delete, uri: "/delete")?.value, "/delete")
        }
        
        testRouter(RouterDict<String>(), routes: routes, check: check)
        testRouter(RouterArray<String>(), routes: routes, check: check)
        testRouter(RouterSortedArray<String>(), routes: routes, check: check)
    }

    static var allTests = [
        ("testSimpleRoutes", testSimpleRoutes),
        ("testParams", testParams),
        ("testMethods", testMethods),
    ]
}
