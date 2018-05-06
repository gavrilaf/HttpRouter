import XCTest
import HttpRouter
import HttpTestApi


class GooglePlusAPITests: XCTestCase {
    
    var router: Router<String>!
    
    override func setUp() {
        router = RouterDict<String>()
        
        for route in GooglePlus.api {
            try! router.add(method: HttpMethod(rawValue: route.0)!, url: URL(string: route.1)!, value: route.1)
        }
    }
    
    func testNonExisting() {
        let testBlock: TestBlock = { (router) in
            XCTAssertNil(router.lookup(method: .get, url: URL(string: "/a/b/c")!))
            XCTAssertNil(router.lookup(method: .delete, url: URL(string: "/people")!))
        }
        
        testRouterS(RouterDict<String>(), routes: GooglePlus.api, testBlock: testBlock)
    }
    
    func testStatic() {
        let testBlock: TestBlock = { (router) in
            XCTAssertEqual("/people", router.lookup(method: .get, url: URL(string: "/people")!)?.value)
            XCTAssertEqual("/activities", router.lookup(method: .get, url: URL(string: "/activities")!)?.value)
        }
        
        testRouterS(RouterDict<String>(), routes: GooglePlus.api, testBlock: testBlock)
    }
    
    func testParams() {
        let testBlock: TestBlock = { (router) in
            let r = router.lookup(method: .post, url: URL(string: "/people/gavrilaf/moments/photos")!)
            XCTAssertNotNil(r)
            XCTAssertEqual(r?.value, "/people/:userId/moments/:collection")
            XCTAssertEqual(r?.urlParams["userId"], "gavrilaf")
            XCTAssertEqual(r?.urlParams["collection"], "photos")
        }
        
        testRouterS(RouterDict<String>(), routes: GooglePlus.api, testBlock: testBlock)
    }
    
    func testAllRoutes() {
        let testBlock: TestBlock = { (router) in
            for route in GooglePlus.api {
                let method = HttpMethod(rawValue: route.0)!
                let path = route.1
                XCTAssertEqual(path, router.lookup(method: method, url: URL(string: path)!)?.value)
            }
        }
        
        testRouterS(RouterDict<String>(), routes: GooglePlus.api, testBlock: testBlock)
    }

    static var allTests = [
        ("testNonExisting", testNonExisting),
        ("testStatic", testStatic),
        ("testParams", testParams),
        ("testAllRoutes", testAllRoutes),
    ]
}
