import UIKit

class FactorPairs : Operation {
    var operationName: String {
        return "Factor Pairs"
    }
    
    var operationAvailableInputs: [(name: String, desc: String)] {
        return [
            ("x", "The number to get all its factor pairs")
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
                result.append(("Factor Pairs", "x", "\(factor) × \(Int(x) / factor)"))
            }
        }
        
        if result.count == 0 {
            return nil
        } else {
            return result
        }
    }
}