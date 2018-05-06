import XCTest
import HttpRouter

class RouterBasicTests: XCTestCase {
    
    func testSimpleRoutes() {
        let routes: [(HttpMethod, URL)] = [
            (.get, URL(string: "/")!),
            (.post, URL(string: "/a")!),
            (.delete, URL(string: "/b/")!),
            (.put, URL(string: "/c/d")!),
            (.get, URL(string: "/public/tickers")!),
            (.put, URL(string: "/auth/register")!),
            (.post, URL(string: "/auth/login")!),
        ]
        
        let testBlock: TestBlock = { (router) in
            for r in routes {
                XCTAssertEqual(r.1.absoluteString, router.lookup(method: r.0, url: r.1)?.value)
            }
        }
        
        testRouter(RouterDict<String>(), routes: routes, testBlock: testBlock)
    }
    
    func testParams() {
        let routes: [(HttpMethod, URL)] = [
            (.get, URL(string: "/:id")!),
            (.get, URL(string: "/:id/:name")!),
            (.get, URL(string: "/:id/vasya")!),
            (.get, URL(string: "/auth/session/:id")!),
        ]
        
        let testBlock: TestBlock = { (router) in
            let r1 = router.lookup(method: .get, url: URL(string: "/id123")!)
            XCTAssertNotNil(r1)
            XCTAssertEqual(r1?.value, "/:id")
            XCTAssertNotNil(r1?.urlParams["id"], "id123")
            
            let r2 = router.lookup(method: .get, url: URL(string: "/id456/john")!)
            XCTAssertNotNil(r2)
            XCTAssertEqual(r2?.value, "/:id/:name")
            XCTAssertEqual(r2?.urlParams.count, 2)
            XCTAssertEqual(r2?.urlParams["id"], "id456")
            XCTAssertEqual(r2?.urlParams["name"], "john")
            
            let r3 = router.lookup(method: .get, url: URL(string: "/id789/vasya")!)
            XCTAssertNotNil(r3)
            XCTAssertEqual(r3?.value, "/:id/vasya")
            XCTAssertEqual(r3?.urlParams.count, 1)
            XCTAssertEqual(r3?.urlParams["id"], "id789")
            
            let r4 = router.lookup(method: .get, url: URL(string: "/auth/session/2")!)
            XCTAssertNotNil(r4)
            XCTAssertEqual(r4?.value, "/auth/session/:id")
            XCTAssertEqual(r4?.urlParams["id"], "2")
        }
        
        testRouter(RouterDict<String>(), routes: routes, testBlock: testBlock)
    }
    
    func testMethods() {
        let routes: [(HttpMethod, URL)] = [
            (.get, URL(string: "/get")!),
            (.post, URL(string: "/post")!),
            (.put, URL(string: "/put")!),
            (.delete, URL(string: "/delete")!),
        ]
        
        let testBlock: TestBlock = { (router) in
            XCTAssertEqual(router.lookup(method: .get, url: URL(string: "/get")!)?.value, "/get")
            XCTAssertEqual(router.lookup(method: .post, url: URL(string: "/post")!)?.value, "/post")
            XCTAssertEqual(router.lookup(method: .put, url: URL(string: "/put")!)?.value, "/put")
            XCTAssertEqual(router.lookup(method: .delete, url: URL(string: "/delete")!)?.value, "/delete")
        }
        
        testRouter(RouterDict<String>(), routes: routes, testBlock: testBlock)
    }

    static var allTests = [
        ("testSimpleRoutes", testSimpleRoutes),
        ("testParams", testParams),
        ("testMethods", testMethods),
    ]
}
