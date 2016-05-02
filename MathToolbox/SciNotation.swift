import UIKit

class SciNotation : Operation {
    var operationName: String {
        return "Scientific Notation"
    }
    
    var operationAvailableInputs: [(name: String, desc: String)] {
        return [
            ("n", "This number will be converted to scientific notation"),
            ("s", "This number will be converted to normal notation")
        ]
    }
    
    var operationRejectFloatingPoint: Bool { return false }
    var operationImage: UIImage? { return nil }
    
    func calculate(inputs: [String : Double]) -> [(name: String, from: String, result: String)]? {
        if inputs.count == 0 {
            return nil
        }
        
        var result: [(name: String, from: String, result: String)] = []
        
        if let s = inputs["s"] {
            let num = NSDecimalNumber(string: s.description)
            result.append(("Normal Notation", "s", num.description))
        }
        
        if let n = inputs["n"] {
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .ScientificStyle
            formatter.exponentSymbol = "e"
            formatter.positiveFormat = "0.#########e0"
            formatter.negativeFormat = "-0.#########e0"
            if let str = formatter.stringFromNumber(n) {
                result.append(("Scientific Notation Style 1", "n", str))
            }
            
            formatter.exponentSymbol = " × 10 ^ "
            formatter.positiveFormat = "0.######### × 10 ^ 0"
            formatter.negativeFormat = "-0.######### × 10 ^ 0"
            
            if let str = formatter.stringFromNumber(n) {
                result.append(("Scientific Notation Style 2", "n", str))
            }
        }
        
        if result.count == 0 {
            return nil
        } else {
            return result
        }
    }
}