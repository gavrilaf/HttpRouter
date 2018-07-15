import Foundation
import HttpRouter

typealias TestBlock<T> = (T) -> Void where T: RouterProtocol, T.StoredValue == String

func testRouter<T>(_ router: Router<T>, routes: [(String, String)], check: TestBlock<Router<T>>)  where T.Element == String {
    for p in routes {
        try! router.add(method: HttpMethod(rawValue: p.0)!, relativePath: p.1, value: p.1)
    }
    
    check(router)
}
