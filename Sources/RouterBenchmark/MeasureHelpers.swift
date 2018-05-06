import Foundation
import HttpRouter

func initRouter(_ router: Router<String>, routes: [(String, String)]) -> Router<String> {
    for route in routes {
        try! router.add(method: HttpMethod(rawValue: route.0)!, url: URL(string: route.1)!, value: route.1)
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
    let name: String
    let router: Router<String>
    let api: [(String, String)]
    let staticUrl: String
    let paramsUrl: String
}

struct PerfRes {
    let name: String
    let staticPerf: Double
    let paramsPerf: Double
    let allApiPerf: Double
}

extension PerfRes: CustomStringConvertible {
    var description: String {
        return "\(name) test: static url: \(staticPerf), url with parameters: \(paramsPerf), all api: \(allApiPerf)"
    }
}

func measureApi(_ req: PerfReq) -> PerfRes {
    let basicIterations = 10000
    
    let staticUrl = URL(string: req.staticUrl)!
    let staticBlock = {
        _ = req.router.lookup(method: .get, url: staticUrl)
    }
    
    let paramsUrl = URL(string: req.paramsUrl)!
    let paramsBlock = {
        _ = req.router.lookup(method: .get, url: paramsUrl)
    }
    
    let allApiBlock = {
        for route in req.api {
            _ = req.router.lookup(method: HttpMethod(rawValue: route.0)!, url: URL(string: route.1)!)
        }
    }
    
    let staticPerf = (measure(iterations: basicIterations, staticBlock) / Double(basicIterations)) * 100
    let paramsPerf = (measure(iterations: basicIterations, paramsBlock) / Double(basicIterations)) * 100
    
    let iterationsForApi = basicIterations / req.api.count
    let allApiPerf = (measure(iterations: iterationsForApi, allApiBlock) / Double(iterationsForApi * req.api.count)) * 100
    
    return PerfRes(name: req.name, staticPerf: staticPerf, paramsPerf: paramsPerf, allApiPerf: allApiPerf)
}
