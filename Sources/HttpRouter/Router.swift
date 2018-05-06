import Foundation

public class Router<T> {
    
    public struct Result<T> {
        public let value: T
        public let urlParams: [String: String]
        public let queryParams: [String: String]
    }
    
    public init() {}
    
    public func add(method: HttpMethod, url: URL, value: T) throws {}
    
    public func lookup(method: HttpMethod, url: URL) -> Result<T>? {
        return nil
    }
}
