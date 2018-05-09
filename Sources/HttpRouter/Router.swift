import Foundation

public struct RouterResult<T> {
    public let value: T
    public let urlParams: [String: String]
    public let queryParams: [String: String]
}

public protocol RouterProtocol {
    associatedtype StoredValue
    
    func add(method: HttpMethod, uri: String, value: StoredValue) throws
    func lookup(method: HttpMethod, uri: String) -> RouterResult<StoredValue>?
}

public final class Router<Node: NodeProtocol>: RouterProtocol {
    
    public typealias StoredValue = Node.Element
    
    public init() {
        root = Node(name: "*", value: nil)
    }
    
    public func add(method: HttpMethod, uri: String, value: Node.Element) throws {
        var current = root
        let components = PathBuilder(method: method, uri: uri).pathComponents
        
        for s in components {
            if s.hasPrefix(":") { // wild
                let wildName = String(s.dropFirst())
                if let wild = current.wildChild {
                    if wild.name == wildName {
                        current = wild
                    } else {
                        throw RouterError.onlyOneWildAllowed
                    }
                } else {
                    let newNode = Node(name: wildName, value: nil)
                    current.wildChild = newNode
                    current = newNode
                }
            } else {
                if let next = current.getChild(name: s) {
                    current = next
                } else {
                    let newNode = Node(name: s, value: nil)
                    current.addChild(node: newNode)
                    current = newNode
                }
            }
        }
        
        current.value = value
    }
    
    public func lookup(method: HttpMethod, uri: String) -> RouterResult<Node.Element>? {
        var current = root
        var urlParams = [String: String]()
        
        let components = PathBuilder(method: method, uri: uri).pathComponents
        
        for s in components {
            if let next = current.getChild(name: s) {
                current = next
            } else if let wild = current.wildChild {
                urlParams[wild.name] = s
                current = wild
            } else {
                return nil
            }
        }
        
        if let value = current.value {
            return RouterResult(value: value, urlParams: urlParams, queryParams: [:])
        }
        
        return nil
    }
    
    var root: Node
}
