import Foundation

public struct PathBuilder {
    
    public init(method: HttpMethod, uri: String) {
        let components = (uri as NSString).pathComponents
        
        var index = 0
        while index < components.count && components[index] == "/" {
            index += 1
        }
        
        var t = Array(components[index...])
        t.append(method.rawValue)
        
        pathComponents = t
    }
    
    public let pathComponents: [String]
}
