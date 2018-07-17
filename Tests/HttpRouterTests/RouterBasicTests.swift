import XCTest
import HttpRouter

class RouterBasicTests: XCTestCase {
    
    func testSimpleRoutes() {
        let routes: [RouterSingleTest] = [
            (.get, "/", "/", nil, nil, nil),
            (.get, "/a", "/a", nil, nil, nil),
            (.get, "/b/", "/b", nil, nil, nil),
            (.get, "/a/b", "/a/b", nil, nil, nil),
            (.get, "/a/b/c/d", "/a/b/c/d", nil, nil, nil),
        ]
        
        testRouter2(RouterDict<String>(), routes)
        testRouter2(RouterArray<String>(), routes)
        testRouter2(RouterSortedArray<String>(), routes)
    }
    
    func testMethods() {
        let routes: [RouterSingleTest] = [
            (.get, "/do", "/do", "get", nil, nil),
            (.post, "/do", "/do", "post", nil, nil),
            (.put, "/do", "/do", "put", nil, nil),
            (.delete, "/do", "/do", "delete", nil, nil),
        ]
        
        testRouter2(RouterDict<String>(), routes)
        testRouter2(RouterArray<String>(), routes)
        testRouter2(RouterSortedArray<String>(), routes)
    }
    
    func testUrlParams() {
        let routes: [RouterSingleTest] = [
            (.get, "/:id", "/id123", nil, ["id": "id123"], nil),
            (.get, "/:id/:name", "id123/ivan", nil, ["id": "id123", "name": "ivan"], nil),
            (.get, "/:id/vasya", "id123/vasya", nil, ["id": "id123"], nil),
            (.post, "/auth/session/:id/do/:action", "/auth/session/1/do/close", nil, ["id": "1", "action": "close"], nil),
        ]
        
        testRouter2(RouterDict<String>(), routes)
        testRouter2(RouterArray<String>(), routes)
        testRouter2(RouterSortedArray<String>(), routes)
    }
    
    func testPathParams() {
        let routes: [RouterSingleTest] = [
            (.get, "/src/*filepath", "/src/", nil, ["filepath": ""], nil),
            (.get, "/src2/*filepath", "/src2/script.js", nil, ["filepath": "script.js"], nil),
            (.get, "/src3/:dir/*filepath", "/src3/scripts/main.js", nil, ["dir": "scripts", "filepath": "main.js"], nil),
            (.get, "/src4/*filepath", "/src4/scripts/main.js", nil, ["filepath": "scripts/main.js"], nil),
        ]
        
        testRouter2(RouterDict<String>(), routes)
        testRouter2(RouterArray<String>(), routes)
        testRouter2(RouterSortedArray<String>(), routes)
    }
    
    func testQueryParams() {
        let routes: [RouterSingleTest] = [
            (.get, "/:id", "/id123?action=delete", nil, ["id": "id123"], ["action": "delete"]),
            (.get, "/user/", "user?name=vasya&lastname=", nil, [:], ["name": "vasya","lastname": ""]),
        ]
        
        testRouter2(RouterDict<String>(), routes)
        testRouter2(RouterArray<String>(), routes)
        testRouter2(RouterSortedArray<String>(), routes)
    }


    func testUnicode() {
        let routes: [RouterSingleTest] = [
            (.get, "/search/:query", "/search/someth!ng+in+ünìcodé", nil, ["query": "someth!ng+in+ünìcodé"], nil),
        ]
        
        testRouter2(RouterDict<String>(), routes)
        testRouter2(RouterArray<String>(), routes)
        testRouter2(RouterSortedArray<String>(), routes)
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

    static var allTests = [
        ("testSimpleRoutes", testSimpleRoutes),
        ("testMethods", testMethods),
        ("testUrlParams", testUrlParams),
        ("testPathParams", testPathParams),
        ("testQueryParams", testQueryParams),
        ("testUnicode", testUnicode),
        ("testNonExistingRoutes", testNonExistingRoutes),
    ]
}
