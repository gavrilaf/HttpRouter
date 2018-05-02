import Foundation


public struct RoutesTree<T> {
    
    public init() {
        root = Node<T>(name: "*", value: nil, children: [:])
    }
    
    public func add(url: URL, value: T) {
        var current = root
        
        for s in url.pathComponents {
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
    
    public func find(byUrl url: URL) -> T? {
        var current = root
        
        for s in url.pathComponents {
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
