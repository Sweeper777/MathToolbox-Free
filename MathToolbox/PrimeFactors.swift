import UIKit

class PrimeFactors: Operation {
    var operationName: String {
        return "Prime Factors"
    }
    
    var operationAvailableInputs: [(name: String, desc: String)] {
        return [
            ("x", "The number to list all of its prime factors.")
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
            var intX = Int(x)
            let largestPrimeFactor = intX / 2
            if largestPrimeFactor > 0 {
                var primeFactors: [Int] = []
                for i in 2...largestPrimeFactor {
                    if isPrime(n: i) && intX % i == 0 {
                        result.append(("Prime Factors", "x", String(i)))
                        primeFactors.append(i)
                    }
                }
                
                var primeFactorProduct: [Int] = []
                
                for factor in primeFactors {
                    while true {
                        if intX % factor == 0 {
                            intX /= factor
                            primeFactorProduct.append(factor)
                            continue
                        } else {
                            break
                        }
                    }
                }
                
                var primeFactorProductResult = ""
                
                for i in 0..<primeFactorProduct.count {
                    let factor = primeFactorProduct[i]
                    if i == primeFactorProduct.count - 1 {
                        primeFactorProductResult += "\(factor)"
                    } else {
                        primeFactorProductResult += "\(factor) × "
                    }
                }
                result.append(("Multiplication of Prime Factors", "x", primeFactorProductResult))
            }
        }
        
        if result.count == 0 {
            return nil
        } else {
            return result
        }
    }

}
