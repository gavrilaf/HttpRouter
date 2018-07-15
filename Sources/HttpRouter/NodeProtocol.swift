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
