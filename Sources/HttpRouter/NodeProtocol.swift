import Foundation

public protocol NodeProtocol: class {
    associatedtype Element
    
    init(name: String, value: Element?)
    
    var name: String { get }
    var value: Element?  { get set }
    
    var wildChild: Self? { get set }
    
    func addChild(node: Self)
    func getChild(name: String) -> Self?
}
