import UIKit

class HexDecBinOct : Operation {
    var operationName: String {
        return "Base Conversions"
    }
    
    var operationAvailableInputs: [(name: String, desc: String)] {
        return [
            ("d", "Number in decimal"),
            ("b", "The base to convert to")
        ]
    }
    
    var operationRejectFloatingPoint: Bool { return true }
    var operationImage: UIImage? { return nil }
    
    func calculate(inputs: [String : Double]) -> [(name: String, from: String, result: String)]? {
        if inputs.count == 0 {
            return nil
        }
        
        var result: [(name: String, from: String, result: String)] = []
        
        if let d = inputs["d"], let b = inputs["b"] {
            if (2...36).contains(b) {
                result.append(("Converted Number", "d, b", String(format: NSLocalizedString("format", comment: ""), String(Int(d), radix: Int(b)), Int(b).description)))
            }
        }
        
        if result.count == 0 {
            return nil
        } else {
            return result
        }
    }
}