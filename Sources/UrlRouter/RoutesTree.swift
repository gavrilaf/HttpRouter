import Foundation


struct RoutesTree<T> {
    
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
    
    init() {
        root = Node<T>(name: "*", value: nil, children: [:])
    }
    
    func add(url: URL, value: T) {
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
    
    
    func get(byUrl url: URL) -> T? {
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
    
    
    var root: Node<T>
    
}
