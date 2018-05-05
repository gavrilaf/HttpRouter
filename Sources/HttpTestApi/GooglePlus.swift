import Foundation

public struct GooglePlus {
    public static let api: [(String, String)] = [
        // People
        ("GET", "/people/:userId"),
        ("GET", "/people"),
        ("GET", "/activities/:activityId/people/:collection"),
        ("GET", "/people/:userId/people/:collection"),
        ("GET", "/people/:userId/openIdConnect"),
    
        // Activities
        ("GET", "/people/:userId/activities/:collection"),
        ("GET", "/activities/:activityId"),
        ("GET", "/activities"),
    
        // Comments
        ("GET", "/activities/:activityId/comments"),
        ("GET", "/comments/:commentId"),
    
        // Moments
        ("POST", "/people/:userId/moments/:collection"),
        ("GET", "/people/:userId/moments/:collection"),
        ("DELETE", "/moments/:id"),
    ]
}
