import XCTest
@testable import HttpRouter

fileprivate func readPathComponents(_ parser: UriParser2) -> [Substring] {
    var components = [Substring]()
    var it = parser.makeIterator()
    while let s = it.next() {
        components.append(s)
    }
    return components
}

fileprivate func check(_ uri: String, _ pathComponets: [Substring], _ queryComponents: [Substring: Substring]) {
    let parser = UriParser(uri: uri)
    XCTAssertEqual(pathComponets, parser.pathComponents)
    XCTAssertEqual(queryComponents, parser.queryParams)
    
    let parser2 = UriParser2(uri: uri)
    XCTAssertEqual(pathComponets, readPathComponents(parser2))
    XCTAssertEqual(queryComponents, parser2.queryParams)
}

class UriParserTests: XCTestCase {
    
    func testPathes() {
        check("/", [], [:])
        check("/////", [], [:])
        check("/user", ["user"], [:])
        check("/user/", ["user"], [:])
        check("//user//", ["user"], [:])
        check("/user/profile", ["user", "profile"], [:])
        check("/user/profile/:id", ["user", "profile", ":id"], [:])
        check("/user/profile/*action", ["user", "profile", "*action"], [:])
        check("/user/profile/:id/*action", ["user", "profile", ":id", "*action"], [:])
    }
    
    func testQueryParams() {
        check("query?a=10", ["query"], ["a": "10"])
        check("query?a=10&b=", ["query"], ["a": "10", "b": ""])
        check("/user/profile/:id?rewrite=true&verbose=0&level=audit", ["user", "profile", ":id"], ["rewrite": "true", "verbose": "0", "level": "audit"])
    }
    
    func testIterator() {
        let uri = UriParser2(uri: "/user/profile/vasya/add")
        var expected = ["user", "profile", "vasya", "add"]
        
        for (indx, s) in uri.enumerated() {
            XCTAssertEqual(expected[indx], String(s))
        }
    }
    
    static var allTests = [
        ("testPathes", testPathes),
        ("testQueryParams", testQueryParams),
        ("testIterator", testIterator)
    ]
}
