import Foundation

/////////////////////////////////////////////////////////////////////////////////
public final class NodeDict<T>: NodeProtocol {
    public typealias Element = T
    
    public required init(name: String, value: Element?) {
        self.name = name
        self.value = value
    }
    
    public var name: String
    public var value: Element?
    public var wildChild: NodeDict?
    
    public func addChild(node: NodeDict) {
        children[node.name] = node
    }
    
    public func getChild(name: String) -> NodeDict? {
        return children[name]
    }
    
    private var children = Dictionary<String, NodeDict>()
}

/////////////////////////////////////////////////////////////////////////////////
public final class NodeArray<T>: NodeProtocol {
    public typealias Element = T
    
    public required init(name: String, value: Element?) {
        self.name = name
        self.value = value
    }
    
    public var name: String
    public var value: Element?
    public var wildChild: NodeArray?
    
    public func addChild(node: NodeArray) {
        children.append(node)
    }
    
    public func getChild(name: String) -> NodeArray? {
        return children.first { return $0.name == name }
    }
    
    private var children = Array<NodeArray>()
}


/////////////////////////////////////////////////////////////////////////////////
public final class NodeSortedArray<T>: NodeProtocol {
    public typealias Element = T
    
    public required init(name: String, value: Element?) {
        self.name = name
        self.value = value
    }
    
    public var name: String
    public var value: Element?
    public var wildChild: NodeSortedArray?
    
    public func addChild(node: NodeSortedArray) {
        children.insert(node, at: bSearch(name: node.name))
    }
    
    public func getChild(name: String) -> NodeSortedArray? {
        let index = bSearch(name: name)
        return index < children.count && children[index].name == name ? children[index] : nil
    }
    
    var children = Array<NodeSortedArray>()
    
    func bSearch(name: String) -> Array<NodeSortedArray>.Index {
        var low = 0
        var high = children.count
        while low != high {
            let mid = low + (high - low) / 2
            if children[mid].name < name {
                low = mid + 1
            } else {
                high = mid
            }
        }
        
        return low
    }
}
