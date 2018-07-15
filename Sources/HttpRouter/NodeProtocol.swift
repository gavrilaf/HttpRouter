import Foundation

public protocol NodeProtocol: class {
    associatedtype Element
    
    init(name: String, allPath: Bool)
    
    var name: String { get }
    
    var allPath: Bool { get }
    var paramChild: Self? { get set }
    
    func addChild(node: Self)
    func getChild(name: String) -> Self?
    
    var value: Element?  { get set }
}
