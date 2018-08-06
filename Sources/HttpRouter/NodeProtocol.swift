import Foundation

public protocol NodeProtocol: class {
    associatedtype Element
    
    init(name: Substring, allPath: Bool)
    
    var name: Substring { get }
    
    var allPath: Bool { get }
    var paramChild: Self? { get set }
    
    func addChild(node: Self)
    func getChild(name: Substring) -> Self?
    
    var value: Element?  { get set }
}

// MARK: -

public enum NodeType: Equatable {
    case regular
    case wildcard(Bool)
}

public protocol NodeProtocol2 {
    var name: Substring { get }
    var type: NodeType { get}
    
    func addChild(name: Substring) throws -> NodeProtocol2?
    func getChild(name: Substring) -> NodeProtocol2?
}

public protocol NodesCollection {
    init(node: NodeProtocol2)
    
    func add(node: NodeProtocol2)
    func get(name: Substring) -> NodeProtocol2?
}

public final class Node2<ChildrenCollection: NodesCollection, Value>: NodeProtocol2 {
    
    public let name: Substring
    public let type: NodeType
    
    var values: ValuesStore<Value>?
    
    var children: ChildrenCollection?
    var wildcardChild: Node2?
    
    init(_ name: Substring, _ type: NodeType) {
        self.name = name
        self.type = type
    }
    
    func createNode(name: Substring) -> Node2 {
        switch name.first! {
        case "*":
            return Node2(name.dropFirst(), .wildcard(true))
        case ":":
            return Node2(name.dropFirst(), .wildcard(false))
        default:
            return Node2(name, .regular)
        }
    }
    
    public func addChild(name: Substring) throws -> NodeProtocol2? {
        let newNode = self.createNode(name: name)
        
        switch newNode.type {
        case .regular:
            if children == nil {
                children = ChildrenCollection(node: newNode)
            } else if let node = children?.get(name: newNode.name) {
                return node
            } else {
                children?.add(node: newNode)
            }
        case .wildcard:
            if let wildcardChild = wildcardChild {
                if wildcardChild.name != newNode.name {
                    throw RouterError.duplicatedWildcard(name)
                }
                return wildcardChild
            }
                
            self.wildcardChild = newNode
        }
        
        return newNode
    }
    
    public func getChild(name: Substring) -> NodeProtocol2? {
        if let node = children?.get(name: name) {
            return node
        }
        
        if let node = wildcardChild {
            return node
        }
        
        return nil
    }
    
    func add(value: Value, forMethod method: HttpMethod) {
        if values == nil {
            values = ValuesStore()
        }
     
        values!.add(value: value, forMethod: method)
    }
     
    func getValue(forMethod method: HttpMethod) -> Value? {
        return values?.getValue(forMethod: method)
    }
}

public final class NodesDictionary: NodesCollection {
    public required init(node: NodeProtocol2) {
        nodes[node.name] = node
    }
    
    public func add(node: NodeProtocol2) {
        nodes[node.name] = node
    }
    
    public func get(name: Substring) -> NodeProtocol2? {
        return nodes[name]
    }
    
    var nodes = [Substring: NodeProtocol2]()
}

struct ValuesStore<Value> {
    var values = [HttpMethod: Value]()
    
    mutating func add(value: Value, forMethod method: HttpMethod) {
        values[method] = value
    }
    
    func getValue(forMethod method: HttpMethod) -> Value? {
        return values[method]
    }
}



