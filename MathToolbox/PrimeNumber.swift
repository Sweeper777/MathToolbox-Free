import UIKit

class PrimeNumber : Operation {
    var operationName: String {
        return "Prime Number"
    }
    
    var operationAvailableInputs: [(name: String, desc: String)] {
        return [
            ("x", "The number to test whether it is a prime")
        ]
    }
    
    var operationRejectFloatingPoint: Bool { return true }
    var operationImage: UIImage? { return nil }
    
    func calculate(inputs: [String : Double]) -> [(name: String, from: String, result: String)]? {
        if inputs.count == 0 {
            return nil
        }
        
        var result: [(name: String, from: String, result: String)] = []
        
        if let x = inputs["x"] {
            if isPrime(n: Int(x)) {
                result.append(("Primality", "x", NSLocalizedString("True", comment: "")))
            } else {
                result.append(("Primality", "x", NSLocalizedString("False", comment: "")))
            }
        }
        
        if result.count == 0 {
            return nil
        } else {
            return result
        }
    }
}

func isPrime(n: Int) -> Bool{
    if n == 2 {
        return true
    }
    
    if n == 3 {
        return true
    }
    
    if n % 2 == 0 {
        return false
    }
    
    if n % 3 == 0 {
        return false
    }
    
    var i = 5
    var w = 2
    
    while i * i < n {
        if n % i == 0 {
            return false
        }
        i += w
        w = 6 - w
    }
    return true
}
