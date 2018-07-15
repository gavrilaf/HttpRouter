import XCTest
@testable import HttpRouter

class UriParserTests: XCTestCase {
    
    func testPathes() {
        XCTAssertEqual([], UriParser(uri: "/").pathComponents)
        XCTAssertEqual([], UriParser(uri: "/////").pathComponents)
        XCTAssertEqual(["user"], UriParser(uri: "/user").pathComponents)
        XCTAssertEqual(["user"], UriParser(uri: "/user/").pathComponents)
        XCTAssertEqual(["user"], UriParser(uri: "//user//").pathComponents)
        XCTAssertEqual(["user", "profile"], UriParser(uri: "/user/profile").pathComponents)
        XCTAssertEqual(["user", "profile", ":id"], UriParser(uri: "/user/profile/:id").pathComponents)
        XCTAssertEqual(["user", "profile", "*action"], UriParser(uri: "/user/profile/*action").pathComponents)
        XCTAssertEqual(["user", "profile", ":id", "*action"], UriParser(uri: "/user/profile/:id/*action").pathComponents)
    }
    
    func testQueryParams() {
        XCTAssertEqual([:], UriParser(uri: "/").queryParams)
        XCTAssertEqual(["a": "10"], UriParser(uri: "query?a=10").queryParams)
        XCTAssertEqual(["a": "10", "b": ""], UriParser(uri: "query?a=10&b=").queryParams)
    }
    
    static var allTests = [
        ("testPathes", testPathes),
        ("testQueryParams", testQueryParams),
    ]
}
