import XCTest
import HttpRouter

class UriParserTests: XCTestCase {
    
   func testSimpleUri() {
        XCTAssertEqual(["GET"], PathBuilder(method: .get, uri:"//").pathComponents)
        XCTAssertEqual(["a", "b", "c", "POST"], PathBuilder(method: .post, uri:"/a/b/c").pathComponents)
        XCTAssertEqual(["people", "gavrilaf", "moments", "photos", "GET"], PathBuilder(method: .get, uri:"/people/gavrilaf/moments/photos").pathComponents)
        XCTAssertEqual(["user", "repos", "GET"], PathBuilder(method: .get, uri:"user/repos").pathComponents)
    }
}
