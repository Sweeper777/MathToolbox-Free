import UIKit

class Factors : Operation {
    var operationName: String {
        return "Factors"
    }
    
    var operationAvailableInputs: [(name: String, desc: String)] {
        return [
            ("x", "All factors of this number and its greatest common factor with y will be calculated"),
            ("y", "All factors of this number and its greatest common factor with x will be calculated")
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
            let factors = getFactors(of: Int(x))
            for factor in factors {
                result.append(("Factors", "x", String(factor)))
            }
        }
        
        if let y = inputs["y"] {
            let factors = getFactors(of: Int(y))
            for factor in factors {
                result.append(("Factors", "y", String(factor)))
            }
        }
        
        if let x = inputs["x"], let y = inputs["y"] {
            let xFactors = getFactors(of: Int(x))
            let yFactors = getFactors(of: Int(y))
            var greatestCommonFactor = 1
            if !(xFactors.isEmpty || yFactors.isEmpty) {
                for factor in xFactors {
                    if yFactors.contains(factor) {
                        greatestCommonFactor = factor
                    }
                }
                result.append(("Greatest Common Factor", "x, y", String(greatestCommonFactor)))
            }
        }
        
        if result.count == 0 {
            return nil
        } else {
            return result
        }
    }
}

func getFactors(of x: Int) -> [Int] {
    let largestFactor = x / 2
    var arr: [Int] = []
    
    if largestFactor < 0 {
        for i in 1...(-largestFactor) {
            if x % i == 0 {
                arr.append(-i)
            }
        }
        return arr
    }
    
    if largestFactor == 0 {
        return []
    }
    
    for i in 1...largestFactor {
        if x % i == 0 {
            arr.append(i)
        }
    }
    
    if x != 1 {
        arr.append((x))
    }
    
    return arr
}