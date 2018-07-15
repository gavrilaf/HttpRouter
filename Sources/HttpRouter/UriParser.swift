import Foundation

struct UriParser {
    
    static let questionMark = Character("?")
    static let slash = Character("/")
    static let amp = Character("&")
    static let eq = Character("=")
    
    let pathComponents: [Substring]
    let queryParams: [Substring: Substring]
    
    init(uri: String) {
        let components = uri.split(separator: UriParser.questionMark)
        
        switch components.count {
        case 0:
            pathComponents = []
            queryParams = [:]
        case 1:
            pathComponents = UriParser.parsePath(components[0])
            queryParams = [:]
        default:
            pathComponents = UriParser.parsePath(components[0])
            queryParams = UriParser.parseQuery(components[1])
        }
    }
    
    static func parsePath(_ s: Substring) -> [Substring] {
        return s.split(separator: UriParser.slash)
    }
    
    static func parseQuery(_ s: Substring) -> [Substring: Substring] {
        let params = s.split(separator: UriParser.amp)
        
        var res = [Substring: Substring]()
        params.forEach {
            let pp = $0.split(separator: UriParser.eq)
            if pp.count == 1 {
                res[pp[0]] = ""
            } else if pp.count > 1 {
                res[pp[0]] = pp[1]
            }
        }
        return res
    }
    
}
