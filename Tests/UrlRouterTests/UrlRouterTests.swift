import XCTest
@testable import UrlRouter

class UrlRouterTests: XCTestCase {
    func testSimpleRoutes() {
        let urls = [
            URL(string: "/")!,
            URL(string: "/a")!,
            URL(string: "/b/")!,
            URL(string: "/c/d")!,
            URL(string: "/public/tickers")!,
            URL(string: "/auth/register")!,
            URL(string: "/auth/login")!,
        ]
        
        let tree = RoutesTree<Int>()
        
        for (i, u) in urls.enumerated() {
            tree.add(url: u, value: i)
        }
        
        for (i, u) in urls.enumerated() {
            let v = tree.get(byUrl: u)
            XCTAssertEqual(i, v)
        }
    }

    static var allTests = [
        ("testSimpleRoutes", testSimpleRoutes),
    ]
}
