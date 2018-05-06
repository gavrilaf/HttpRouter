import Foundation
import HttpRouter
import HttpTestApi


func measureGithub() {
    let router = RoutesTree<String>()
    for route in Github.api {
        try! router.add(method: HttpMethod(rawValue: route.0)!, url: URL(string: route.1)!, value: route.1)
    }
    
    func lookupStatic() {
        _ = router.lookup(method: .get, url: URL(string: "/user/repos")!)
    }
    
    func lookupParams() {
        _ = router.lookup(method: .get, url: URL(string: "/repos/gavrilaf/httprouter/stargazers")!)
    }
    
    func lookupAllRoutes() {
        for route in Github.api {
            _ = router.lookup(method: HttpMethod(rawValue: route.0)!, url: URL(string: route.1)!)
        }
    }
    
    print("Measure github api")
    
    measure(title: "static", iterations: 10000, lookupStatic)
    measure(title: "with params", iterations: 10000, lookupParams)
    measure(title: "all routes", iterations: 1000, lookupAllRoutes)
}
