import Foundation

public struct RouterResult<T> {
    public let value: T
    public let urlParams: [Substring: Substring]
    public let queryParams: [Substring: Substring]
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
                    let newNode = Node(name: paramName, allPath: s.hasPrefix("*"))
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
        let methodNode = Node(name: method.rawValue.substr, allPath: false)
        methodNode.value = value
        
        current.addChild(node: methodNode)
    }
    
    public func lookup(method: HttpMethod, uri: String) -> RouterResult<StoredValue>? {
        var current = root
        var urlParams = [Substring: Substring]()
        
        let methodStr = method.rawValue.substr
        
        let parsedUri = UriParser(uri: uri)
        var components = parsedUri.pathComponents
        
        components.append(methodStr) // POST: /action/send -> ['action', 'send', 'POST']
        
        for (indx, s) in components.enumerated() {
            if let next = current.getChild(name: s) {
                current = next
            } else if let paramChild = current.paramChild {
                if paramChild.allPath {
                    let joined = components[indx..<components.count-1].joined(separator: "/")
                    urlParams[paramChild.name] = joined.substr
                    if let methodChild = paramChild.getChild(name: methodStr) {
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

// MARK: -
public final class Router2<Container: NodesCollection, Value>: RouterProtocol {
    
    public init() {
        root = Node2("", .regular)
    }
    
    public func add(method: HttpMethod, relativePath: String, value: StoredValue) throws {
        var current = root
        let parsedUri = UriParser2(uri: relativePath)
        
        for s in parsedUri {
            current = try current.addChild(name: s) as! Node2<Container, Value>
        }
        
        // add value for HTTPMethod
        current.add(value: value, forMethod: method)
    }
    
    public func lookup(method: HttpMethod, uri: String) -> RouterResult<Value>? {
        var current: NodeProtocol2 = root
        var urlParams = [Substring: Substring]()
        
        let parsedUri = UriParser2(uri: uri)
        var it = parsedUri.makeIterator()
        outer: while let s = it.next() {
            guard let node = current.getChild(name: s) else { return nil }
            
            switch node.type {
            case .regular:
                current = node
            case .wildcard(let capturePath):
                if capturePath {
                    urlParams[node.name] = it.remainingPath()
                    current = node
                    break outer
                } else {
                    urlParams[node.name] = s
                    current = node
                }
            }
        }
        
        if let value = (current as! Node2<Container, Value>).getValue(forMethod: method) {
           return RouterResult(value: value, urlParams: urlParams, queryParams: parsedUri.queryParams)
        }
        
        return nil
    }
    
    var root: Node2<Container, Value>
}

