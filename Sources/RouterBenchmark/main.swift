import Foundation

print("Router perfomance test")

var measurements = [Measurement]()
(1...3).forEach {
    print("Attempt - \($0)")
    let m = RunMeasure()
    PrintResults(m)
    measurements.append(contentsOf: m)
}

PrintTotalResults(measurements)
