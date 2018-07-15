import Foundation
import HttpRouter
import HttpTestApi


func RunMeasure() -> [Measurement] {
    let requests: [PerfRequest] = [
        PerfRequest(apiName: "Github",
                    api: Github.api,
                    staticUrl: "/user/repos",
                    paramsUrl: "/repos/gavrilaf/httprouter/stargazers"),
        PerfRequest(apiName: "GooglePlus",
                    api: GooglePlus.api,
                    staticUrl: "/activities",
                    paramsUrl: "/people/gavrilaf/moments/photos"),
        PerfRequest(apiName: "Parse",
                    api: Parse.api,
                    staticUrl: "/1/users",
                    paramsUrl: "/1/classes/swift/123456789")
    ]
    
    let results = requests.flatMap {
        return [measureApi(RouterDict<String>(), $0), measureApi(RouterArray<String>(), $0), measureApi(RouterSortedArray<String>(), $0)]
    }
    
    return results
}

func PrintResults(_ measurements: [Measurement]) {
    let group = Dictionary(grouping: measurements, by: { $0.routerName })
    let meanResults: [(String, Double)] = group.map { (t) in
        let total = t.value.reduce(0.0) { res, p in
            return res + p.staticPerf + p.paramsPerf + p.allApiPerf
        }
        return (t.key, total / Double(3*t.value.count))
    }.sorted {
        return $0.1 < $1.1
    }
    
    print("\n*** Results:")
    meanResults.forEach {
        print("Mean value for \($0.0): \($0.1)")
    }
    print("*********************")
}

func PrintTotalResults(_ measurements: [Measurement]) {
    let group = measurements.reduce(into: [String: (Int, Double)]()) { counts, res in
        let counter = counts[res.routerName] ?? (0, 0.0)
        counts[res.routerName] = (counter.0 + 3, counter.1 + res.allApiPerf + res.staticPerf + res.paramsPerf)
    }
    
    let meanResults = group.map { t in
        return (t.key, t.value.1 / (Double)(t.value.0))
    }.sorted {
        return $0.1 < $1.1
    }
    
    print("\n*** Total results:")
    meanResults.forEach {
        print("Total value for \($0.0): \($0.1)")
    }
    print("*********************")
}

