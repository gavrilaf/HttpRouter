import Foundation

print("Router perfomance test")

(1...10).forEach { (n) in
    print("\nAttempt \(n)\n")
    RunMeasure()
}

