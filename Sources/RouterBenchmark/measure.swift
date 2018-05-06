import Foundation

func measure(title: String, iterations: Int, _ block: () -> Void) {
    let startTime = CFAbsoluteTimeGetCurrent()
    (0..<iterations).forEach { _ in
        block()
    }
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    
    print("Time elapsed for \(title)")
    print("Total time for \(iterations) iterations: \(timeElapsed)")
    print("************************************************")
}
