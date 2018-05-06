import XCTest
import HttpRouter
import HttpTestApi


class GooglePlusAPITests: XCTestCase {
    
    var router: RoutesTree<String>!
    
    override func setUp() {
        router = RoutesTree<String>()
        
        for route in GooglePlus.api {
            try! router.add(method: HttpMethod(rawValue: route.0)!, url: URL(string: route.1)!, value: route.1)
        }
    }
    
    func testNonExisting() {
        XCTAssertNil(router.lookup(method: .get, url: URL(string: "/a/b/c")!))
        XCTAssertNil(router.lookup(method: .delete, url: URL(string: "/people")!))
    }
    
    func testStatic() {
        XCTAssertEqual("/people", router.lookup(method: .get, url: URL(string: "/people")!)?.value)
        XCTAssertEqual("/activities", router.lookup(method: .get, url: URL(string: "/activities")!)?.value)
    }
    
    func testParams() {
        let r = router.lookup(method: .post, url: URL(string: "/people/gavrilaf/moments/photos")!)
        
        XCTAssertNotNil(r)
        XCTAssertEqual(r?.value, "/people/:userId/moments/:collection")
        XCTAssertEqual(r?.urlParams["userId"], "gavrilaf")
        XCTAssertEqual(r?.urlParams["collection"], "photos")
    }
    
    func testAllRoutes() {
        for route in GooglePlus.api {
            let method = HttpMethod(rawValue: route.0)!
            let path = route.1
            XCTAssertEqual(path, router.lookup(method: method, url: URL(string: path)!)?.value)
        }
    }

    static var allTests = [
        ("testNonExisting", testNonExisting),
        ("testStatic", testStatic),
        ("testParams", testParams),
        ("testAllRoutes", testAllRoutes),
    ]
}
