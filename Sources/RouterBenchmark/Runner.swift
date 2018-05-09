import Foundation
import HttpRouter
import HttpTestApi


func RunMeasure() {
    let requests: [PerfReq] = [
        PerfReq(apiName: "Github",
                api: Github.api,
                staticUrl: "/user/repos",
                paramsUrl: "/repos/gavrilaf/httprouter/stargazers"),
        PerfReq(apiName: "GooglePlus",
                api: GooglePlus.api,
                staticUrl: "/activities",
                paramsUrl: "/people/gavrilaf/moments/photos"),
        PerfReq(apiName: "Parse",
                api: Parse.api,
                staticUrl: "/1/users",
                paramsUrl: "/1/classes/swift/123456789")
    ]
    
    let results = requests.flatMap {
        return [measureApi(RouterDict<String>(), $0), measureApi(RouterArray<String>(), $0), measureApi(RouterSortedArray<String>(), $0)]
    }
    
    let group = Dictionary(grouping: results, by: { $0.routerName })
    
    print("*** results ***")
    results.forEach { print("\($0)") }
    
    print("\n\n*** mean ***\n")
    
    var meanResults = [(String, Double)]()
    
    for p in group {
        var mean = p.value.reduce(0.0) { (sum, r) in return sum + r.staticPerf + r.paramsPerf + r.allApiPerf }
        mean /= Double(3 + p.value.count)
        meanResults.append((p.key, mean))
    }
    
    meanResults.sort { return $0.1 < $1.1 }
    
    meanResults.forEach {
        print("Mean value for \($0.0): \($0.1)")
    }
}
