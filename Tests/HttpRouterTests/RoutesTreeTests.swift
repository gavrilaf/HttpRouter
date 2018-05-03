import XCTest
import HttpRouter

class RoutesTreeTests: XCTestCase {
    
    func testSimpleRoutes() {
        let urls: [(HttpMethod, URL)] = [
            (.get, URL(string: "/")!),
            (.post, URL(string: "/a")!),
            (.delete, URL(string: "/b/")!),
            (.put, URL(string: "/c/d")!),
            (.get, URL(string: "/public/tickers")!),
            (.put, URL(string: "/auth/register")!),
            (.post, URL(string: "/auth/login")!),
        ]
        
        let tree = RoutesTree<Int>()
        
        for (i, u) in urls.enumerated() {
            try! tree.add(method: u.0, url: u.1, value: i)
        }
        
        for (i, u) in urls.enumerated() {
            let v = tree.lookup(method: u.0, url: u.1)
            XCTAssertEqual(i, v?.value)
        }
    }
    
    func testParams() {
        let urls: [(HttpMethod, URL)] = [
            (.get, URL(string: "/:id")!),
            (.get, URL(string: "/:id/:name")!),
            (.get, URL(string: "/:id/vasya")!),
            (.get, URL(string: "/auth/session/:id")!),
        ]
        
        let tree = RoutesTree<String>()
        
        for p in urls {
            try! tree.add(method: p.0, url: p.1, value: p.1.absoluteString)
        }
        
        let r1 = tree.lookup(method: .get, url: URL(string: "/id123")!)
        XCTAssertNotNil(r1)
        XCTAssertEqual(r1?.value, "/:id")
        XCTAssertNotNil(r1?.urlParams["id"], "id123")
        
        let r2 = tree.lookup(method: .get, url: URL(string: "/id456/john")!)
        XCTAssertNotNil(r2)
        XCTAssertEqual(r2?.value, "/:id/:name")
        XCTAssertEqual(r2?.urlParams.count, 2)
        XCTAssertEqual(r2?.urlParams["id"], "id456")
        XCTAssertEqual(r2?.urlParams["name"], "john")
        
        let r3 = tree.lookup(method: .get, url: URL(string: "/id789/vasya")!)
        XCTAssertNotNil(r3)
        XCTAssertEqual(r3?.value, "/:id/vasya")
        XCTAssertEqual(r3?.urlParams.count, 1)
        XCTAssertEqual(r3?.urlParams["id"], "id789")
        
        let r4 = tree.lookup(method: .get, url: URL(string: "/auth/session/2")!)
        XCTAssertNotNil(r4)
        XCTAssertEqual(r4?.value, "/auth/session/:id")
        XCTAssertEqual(r4?.urlParams["id"], "2")
    }

    static var allTests = [
        ("testSimpleRoutes", testSimpleRoutes),
        ("testParams", testParams),
    ]
}
