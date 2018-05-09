import Foundation

print("Router perfomance test")

(1...5).forEach { (n) in
    print("\nAttempt \(n)\n")
    RunMeasure()
}

