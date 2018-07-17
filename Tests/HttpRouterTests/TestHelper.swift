import XCTest
import Foundation
import HttpRouter

typealias TestBlock<T: RouterProtocol> = (T) -> Void where T.StoredValue == String

func testRouter<T: RouterProtocol>(_ router: T, routes: [(String, String)], check: TestBlock<T>)  where T.StoredValue == String {
    for p in routes {
        XCTAssertNoThrow(try router.add(method: HttpMethod(rawValue: p.0)!, relativePath: p.1, value: p.1))
    }
    
    check(router)
}

func checkRoute<T: RouterProtocol>(_ router: T, _ method: HttpMethod, _ uri: String, _ pattern: String, _ urlParams: [Substring: Substring]? = nil, _ queryParams: [Substring: Substring]? = nil) where T.StoredValue == String {
    let route = router.lookup(method: method, uri: uri)
    XCTAssertNotNil(route)
    XCTAssertEqual(pattern, route?.value)
    
    if let urlParams = urlParams {
        XCTAssertEqual(urlParams, route?.urlParams)
    }
    
    if let queryParams = queryParams {
        XCTAssertEqual(queryParams, route?.queryParams)
    }
}

// MARK: -

// (method, relativePath, request, value, urlParams, queryParams)
typealias RouterSingleTest = (HttpMethod, String, String, String?, [Substring: Substring]?, [Substring: Substring]?)

func testRouter2<T: RouterProtocol>(_ router: T, _ tests: [RouterSingleTest]) where T.StoredValue == String {
    for test in tests {
        XCTAssertNoThrow(try router.add(method: test.0, relativePath: test.1, value: test.3 ?? test.1)) // Use passed value or relative path
    }
    
    for test in tests {
        let route = router.lookup(method: test.0, uri: test.2)
        XCTAssertNotNil(route)
        
        let expectedValue = test.3 ?? test.1
        XCTAssertEqual(expectedValue, route?.value)
        
        if let urlParams = test.4 {
            XCTAssertEqual(urlParams, route?.urlParams)
        }
        
        if let queryParams = test.5 {
            XCTAssertEqual(queryParams, route?.queryParams)
        }
    }
}

