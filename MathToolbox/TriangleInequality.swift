import UIKit

class TriangleInequality : Operation {
    var operationName: String {
        return "Triangle Inequality"
    }
    
    var operationAvailableInputs: [(name: String, desc: String)] {
        return [
            ("s1", "Side Length"),
            ("s2", "Side Length"),
            ("s3", "Side Length")
        ]
    }
    
    var operationRejectFloatingPoint: Bool { return false }
    var operationImage: UIImage? { return nil }
    
    func calculate(inputs: [String : Double]) -> [(name: String, from: String, result: String)]? {
        if inputs.count == 0 {
            return nil
        }
        
        var result: [(name: String, from: String, result: String)] = []
        
        if let s1 = inputs["s1"], let s2 = inputs["s2"], let s3 = inputs["s3"] {
            if s1 + s2 > s3 && s1 + s3 > s2 && s2 + s3 > s1 {
                result.append(("Is Possible to Form Triangle?", "s1, s2, s3", NSLocalizedString("True", comment: "")))
            } else {
                result.append(("Is Possible to Form Triangle?", "s1, s2, s3", NSLocalizedString("True", comment: "")))
            }
        } else {
            
            if let s1 = inputs["s1"], let s2 = inputs["s2"] {
                result.append(("s3", "s1, s2", "≤ \(correctToSigFigAndPi(s1 + s2, false))"))
            }
            
            if let s1 = inputs["s1"], let s3 = inputs["s3"] {
                result.append(("s2", "s1, s3", "≤ \(correctToSigFigAndPi(s1 + s3, false))"))
            }
            
            if let s2 = inputs["s2"], let s3 = inputs["s3"] {
                result.append(("s1", "s2, s3", "≤ \(correctToSigFigAndPi(s2 + s3, false))"))
            }
        }
        if result.count == 0 {
            return nil
        } else {
            return result
        }
    }
}