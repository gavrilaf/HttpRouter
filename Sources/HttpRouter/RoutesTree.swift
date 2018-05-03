import Foundation

public struct RoutesTree<T> {
    
    public struct Result<T> {
        public let value: T
        public let urlParams: [String: String]
        public let queryParams: [String: String]
    }
    
    public init() {
        root = Node<T>(name: "*", value: nil, children: [:])
    }
    
    public func add(method: HttpMethod, url: URL, value: T) throws {
        var current = root
        let components = [method.rawValue] + url.pathComponents
        
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
                    let newNode = Node<T>(name: wildName, value: nil, children: [:])
                    current.wildChild = newNode
                    current = newNode
                }
            } else {
                if let next = current.children[s] {
                    current = next
                } else {
                    let newNode = Node<T>(name: s, value: nil, children: [:])
                    current.children[s] = newNode
                    current = newNode
                }
            }
        }
        
        current.value = value
    }
    
    public func lookup(method: HttpMethod, url: URL) -> Result<T>? {
        var current = root
        var urlParams = [String: String]()
        
        let components = [method.rawValue] + url.pathComponents
        for s in components {
            if let next = current.children[s] {
                current = next
            } else if let wild = current.wildChild {
                urlParams[wild.name] = s
                current = wild
            } else {
                return nil
            }
        }
        
        if let value = current.value {
            return Result(value: value, urlParams: urlParams, queryParams: [:])
        }
        
        return nil
    }
    
    // MARK: - private
    
    class Node<T> {
        init(name: String, value: T?, children: Dictionary<String, Node>) {
            self.name = name
            self.value = value
            self.children = children
        }
        
        var name: String
        var value: T?
        
        var children: Dictionary<String, Node>
        var wildChild: Node<T>?
    }
    
    var root: Node<T>
}
