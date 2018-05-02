import Foundation


public struct RoutesTree<T> {
    
    public init() {
        root = Node<T>(name: "*", value: nil, children: [:])
    }
    
    public func add(method: HttpMethod, url: URL, value: T) {
        var current = root
        let components = [method.rawValue] + url.pathComponents
        for s in components {
            if let next = current.children[s] {
                current = next
            } else {
                let newNode = Node<T>(name: s, value: nil, children: [:])
                current.children[s] = newNode
                current = newNode
            }
        }
        
        current.value = value
    }
    
    public func find(method: HttpMethod, url: URL) -> T? {
        var current = root
        
        let components = [method.rawValue] + url.pathComponents
        for s in components {
            if let next = current.children[s] {
                current = next
            } else {
                return nil
            }
        }
        
        return current.value
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
    }
    
    var root: Node<T>
}
