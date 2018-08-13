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
    
    func testPath() {
        let uri = UriParser2(uri: "src/script.js")
        var it = uri.makeIterator()
        
        XCTAssertEqual("src", it.next())
        //XCTAssertEqual("src/script.js", it.remainingPath())
        XCTAssertEqual("script.js", it.next())
        XCTAssertEqual("script.js", it.remainingPath())
        
        
        /*let uri2 = UriParser2(uri: "open/src/script.js")
        var it2 = uri2.makeIterator()
        
        XCTAssertEqual("open", it2.next())
        XCTAssertEqual("src", it2.next())
        XCTAssertEqual("src/script.js", it2.remainingPath())*/
    }
    
    static var allTests = [
        ("testPathes", testPathes),
        ("testQueryParams", testQueryParams),
        ("testIterator", testIterator),
        ("testPath", testPath),
    ]
}
