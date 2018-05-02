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
            tree.add(method: u.0, url: u.1, value: i)
        }
        
        for (i, u) in urls.enumerated() {
            let v = tree.find(method: u.0, url: u.1)
            XCTAssertEqual(i, v)
        }
    }

    static var allTests = [
        ("testSimpleRoutes", testSimpleRoutes),
    ]
}
