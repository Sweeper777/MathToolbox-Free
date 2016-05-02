import UIKit

class LeastCommonMultiple : Operation {
    var operationName: String {
        return "Least Common Multiple"
    }
    
    var operationAvailableInputs: [(name: String, desc: String)] {
        return [
            ("x", "The first number"),
            ("y", "The second number")
        ]
    }
    
    var operationRejectFloatingPoint: Bool { return false }
    var operationImage: UIImage? { return nil }
    
    func calculate(inputs: [String : Double]) -> [(name: String, from: String, result: String)]? {
        if inputs.count == 0 {
            return nil
        }
        
        var result: [(name: String, from: String, result: String)] = []
        
        if let x = inputs["x"], let y = inputs["y"] {
            result.append(("Least Common Multiple", "x, y", correctToSigFigAndPi(leastCommonMultiple(of: x, and: y), false)))
        }
        
        if result.count == 0 {
            return nil
        } else {
            return result
        }
    }

}

func leastCommonMultiple(of x: Double, and y: Double) -> Double {
    let isNegative = x < 0 || y < 0
    let largerNumber = max(x, y)
    let smallerNumber = min(x, y)
    if smallerNumber == 0 {
        return 0
    }
    
    if largerNumber % smallerNumber == 0 {
        return isNegative ? -largerNumber : largerNumber
    }
    
    var i = 2.0
    while (largerNumber * i) % smallerNumber != 0 {
        i += 1
    }
    return (isNegative ? -largerNumber : largerNumber) * i
}