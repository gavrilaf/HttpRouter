import Foundation
import HttpRouter

func initRouter<T>(_ router: Router<T>, routes: [(String, String)]) -> Router<T> where T.Element == String {
    for route in routes {
        try! router.add(method: HttpMethod(rawValue: route.0)!, uri: route.1, value: route.1)
    }
    
    return router
}

func measure(iterations: Int, _ block: () -> Void) -> Double {
    let startTime = CFAbsoluteTimeGetCurrent()
    (0..<iterations).forEach { _ in
        block()
    }
    return CFAbsoluteTimeGetCurrent() - startTime
}

struct PerfReq {
    let apiName: String
    let api: [(String, String)]
    let staticUrl: String
    let paramsUrl: String
}

struct PerfRes {
    let apiName: String
    let routerName: String
    let staticPerf: Double
    let paramsPerf: Double
    let allApiPerf: Double
}

extension PerfRes: CustomStringConvertible {
    var description: String {
        return "\(apiName) : \(routerName): static url: \(staticPerf), url with parameters: \(paramsPerf), all api: \(allApiPerf)"
    }
}

func measureApi<T>(_ router: Router<T>, _ req: PerfReq) -> PerfRes where T.Element == String {
    let basicIterations = 50000
    
    let staticBlock = {
        _ = router.lookup(method: .get, uri: req.staticUrl)
    }
    
    let paramsBlock = {
        _ = router.lookup(method: .get, uri: req.paramsUrl)
    }
    
    let allApiBlock = {
        for route in req.api {
            _ = router.lookup(method: HttpMethod(rawValue: route.0)!, uri: route.1)
        }
    }
    
    let staticPerf = (measure(iterations: basicIterations, staticBlock) / Double(basicIterations)) * 100
    let paramsPerf = (measure(iterations: basicIterations, paramsBlock) / Double(basicIterations)) * 100
    
    let iterationsForApi = basicIterations / req.api.count
    let allApiPerf = (measure(iterations: iterationsForApi, allApiBlock) / Double(iterationsForApi * req.api.count)) * 100
    
    return PerfRes(apiName: req.apiName, routerName: "\(type(of: router))", staticPerf: staticPerf, paramsPerf: paramsPerf, allApiPerf: allApiPerf)
}
