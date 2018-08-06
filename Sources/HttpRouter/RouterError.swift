import Foundation

enum RouterError: Error {
    case invalidPath(path: String)
    case notFound(method: HttpMethod, uri: String)
    case duplicatedWildcard(Substring)
}
