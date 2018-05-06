import Foundation
import HttpRouter

typealias TestBlock = (Router<String>) -> Void

func testRouter(_ router: Router<String>, routes: [(HttpMethod, URL)], testBlock: TestBlock) {
    for p in routes {
        try! router.add(method: p.0, url: p.1, value: p.1.absoluteString)
    }
    
    testBlock(router)
}

func testRouterS(_ router: Router<String>, routes: [(String, String)], testBlock: TestBlock) {
    for p in routes {
        try! router.add(method: HttpMethod(rawValue: p.0)!, url: URL(string: p.1)!, value: p.1)
    }
    
    testBlock(router)
}
