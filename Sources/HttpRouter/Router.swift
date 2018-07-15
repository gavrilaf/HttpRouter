import Foundation

public typealias StringDict = [String: String]

public struct RouterResult<T> {
    public let value: T
    public let urlParams: [String: String]
    public let queryParams: [String: String]
}

public protocol RouterProtocol {
    associatedtype StoredValue
    
    func add(method: HttpMethod, relativePath: String, value: StoredValue) throws
    func lookup(method: HttpMethod, uri: String) -> RouterResult<StoredValue>?
}

public final class Router<Node: NodeProtocol>: RouterProtocol {
    
    public typealias StoredValue = Node.Element
    
    public init() {
        root = Node(name: "*", allPath: false)
    }
    
    public func add(method: HttpMethod, relativePath: String, value: StoredValue) throws {
        var current = root
        let components = UriParser(uri: relativePath).pathComponents
        
        try components.forEach { (s) in
            if current.allPath { // allPath param with children
                throw RouterError.invalidPath(path: relativePath)
            }
            
            if s.hasPrefix(":") || s.hasPrefix("*") { // param node
                let paramName = s.dropFirst()
                if let paramChild = current.paramChild {
                    if paramChild.name == paramName {
                        current = paramChild
                    } else { // different param nodes on the one level
                        throw RouterError.invalidPath(path: relativePath)
                    }
                } else {
                    let newNode = Node(name: String(paramName), allPath: s.hasPrefix("*"))
                    current.paramChild = newNode
                    current = newNode
                }
            } else {
                if let next = current.getChild(name: s) {
                    current = next
                } else {
                    let newNode = Node(name: s, allPath: false)
                    current.addChild(node: newNode)
                    current = newNode
                }
            }
        }
        
        // create node with HTTP method
        let methodNode = Node(name: method.rawValue, allPath: false)
        methodNode.value = value
        
        current.addChild(node: methodNode)
    }
    
    public func lookup(method: HttpMethod, uri: String) -> RouterResult<StoredValue>? {
        var current = root
        var urlParams = StringDict()
        
        let parsedUri = UriParser(uri: uri)
        var components = parsedUri.pathComponents
        components.append(method.rawValue) // POST: /action/send -> ['action', 'send', 'POST']
        
        for (indx, s) in components.enumerated() {
            if let next = current.getChild(name: s) {
                current = next
            } else if let paramChild = current.paramChild {
                if paramChild.allPath {
                    urlParams[paramChild.name] = components[indx..<components.count-1].joined(separator: "/")
                    if let methodChild = paramChild.getChild(name: method.rawValue) {
                        current = methodChild
                        break
                    } else {
                        return nil //Result(error: RouterError.notFound(method: method, uri: uri))
                    }
                } else {
                    urlParams[paramChild.name] = s
                    current = paramChild
                }
            } else {
                return nil //Result(error: RouterError.notFound(method: method, uri: uri))
            }
        }
        
        if let value = current.value {
            return RouterResult(value: value, urlParams: urlParams, queryParams: parsedUri.queryParams)
        } else {
            return nil
        }
    }

    var root: Node
}
