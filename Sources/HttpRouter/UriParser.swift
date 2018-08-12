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

// MARK:

struct UriParser2 {
    static let questionMark = Character("?")
    static let amp = Character("&")
    static let eq = Character("=")
    
    lazy var queryParams: [Substring: Substring] = {
        if pathEndIndex != uri.endIndex {
            let queryIndex = uri.index(after: pathEndIndex)
            return UriParser2.parseQuery(uri[queryIndex...])
        } else {
            return [:]
        }
    }()
    
    init(uri: String) {
        self.uri = uri
        self.pathEndIndex = uri.index(of: UriParser.questionMark) ?? uri.endIndex
    }
    
    func makeIterator() -> PathIterator {
        return PathIterator(uri: uri[Range(uncheckedBounds: (lower: uri.startIndex, upper: pathEndIndex))])
    }
    
    private let uri: String
    private let pathEndIndex: String.Index
    
    private static func parseQuery(_ s: Substring) -> [Substring: Substring] {
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

struct PathIterator: IteratorProtocol {
    static let slash = Character("/")
    
    init(uri: Substring) {
        self.uri = uri
        self.currentPos = uri.startIndex
        self.previousPos = self.currentPos
    }
    
    mutating func next() -> Substring? {
        guard currentPos < uri.endIndex else { return nil }
        
        let substr = uri[Range(uncheckedBounds: (lower: currentPos, upper: uri.endIndex))]
        if let nextIndex = substr.index(of: PathIterator.slash) {
            let dist = substr.distance(from: substr.startIndex, to: nextIndex)
            let convertedIndex = uri.index(currentPos, offsetBy: dist)
            let result = uri[Range(uncheckedBounds: (lower: currentPos, upper: convertedIndex))]
            
            previousPos = currentPos
            currentPos = uri.index(after: convertedIndex)
            
            if result.isEmpty {
                return next()
            }
            
            return result
        }
        
        currentPos = uri.endIndex
        
        return substr
    }
    
    func remainingPath() -> Substring {
        return uri[Range(uncheckedBounds: (lower: previousPos, upper: uri.endIndex))]
    }
    
    // MARK:
    let uri: Substring
    var currentPos: String.Index
    var previousPos: String.Index
}


