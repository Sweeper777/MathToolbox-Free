import UIKit

class Trapizium: Operation {
    var operationName: String {
        return "Trapizium"
    }
    
    var operationAvailableInputs: [(name: String, desc: String)] {
        return [
            ("b1", "The upper base of the trapizium"),
            ("b2", "The lower base of the trapizium"),
            ("h", "The height (altitude) of the trapizium"),
            ("s1", "The length of the trapizium's left side"),
            ("s2", "The length of the trapizium's right side"),
            ("P", "The perimeter of the trapizium"),
            ("A", "The area of the trapizium")
        ]
    }
    
    var operationRejectFloatingPoint: Bool { return false }
    var operationImage: UIImage? { return UIImage.init(named: "trapizium") }
    
    func calculate (inputs: [String: Double]) -> [(name: String, from: String, result: String)]? {
        if inputs.count == 0 {
            return nil
        }
        
        var result: [(name: String, from: String, result: String)] = []
        
        if let b1 = inputs["b1"], let b2 = inputs["b2"], let h = inputs["h"] {
            result.append(("Area", "b1, b2, h", correctToSigFigAndPi((b1 + b2) * h / 2.0, false)))
        }
        
        if let b1 = inputs["b1"], let b2 = inputs["b2"], let s1 = inputs["s1"], let s2 = inputs["s2"] {
            result.append(("Perimeter", "b1, b2, s1, s2", correctToSigFigAndPi(b1 + b2 + s1 + s2, false)))
        }
        
        if let b1 = inputs["b1"], let b2 = inputs["b2"], let s1 = inputs["s1"], let p = inputs["P"] {
            result.append(("Right Side Length", "b1, b2, s1, P", correctToSigFigAndPi(p - (b1 + b2 + s1), false)))
        }
        
        if let b1 = inputs["b1"], let b2 = inputs["b2"], let p = inputs["P"], let s2 = inputs["s2"] {
            result.append(("Left Side Length", "b1, b2, s2, P", correctToSigFigAndPi(p - (b1 + b2 + s2), false)))
        }
        
        if let b1 = inputs["b1"], let p = inputs["P"], let s1 = inputs["s1"], let s2 = inputs["s2"] {
            let b2 = p - (b1 + s1 + s2)
            result.append(("Lower Base", "b1, s1, s2, P", correctToSigFigAndPi(b2, false)))
            if let h = inputs["h"] {
                result.append(("Area", "b1, s1, s2, P, h", correctToSigFigAndPi((b1 + b2) * h / 2.0, false)))
            }
        }
        
        if let p = inputs["P"], let b2 = inputs["b2"], let s1 = inputs["s1"], let s2 = inputs["s2"] {
            let b1 = p - (b2 + s1 + s2)
            result.append(("Upper Base", "b2, s1, s2, P", correctToSigFigAndPi(b1, false)))
            if let h = inputs["h"] {
                result.append(("Area", "b2, s1, s2, P, h", correctToSigFigAndPi((b1 + b2) * h / 2.0, false)))
            }
        }
        
        if let a = inputs["A"], let b1 = inputs["b1"], let b2 = inputs["b2"] {
            result.append(("Height", "A, b1, b2", correctToSigFigAndPi(a * 2 / (b1 + b2), false)))
        }
        
        if let a = inputs["A"], let b1 = inputs["b1"], let h = inputs["h"] {
            let b2 = a * 2 / h - b1
            result.append(("Lower Base", "A, b1, h", correctToSigFigAndPi(b1, false)))
            if let s1 = inputs["s1"], let s2 = inputs["s2"] {
                result.append(("Perimeter", "A, b1, h, s1, s2", correctToSigFigAndPi(b1 + b2 + s1 + s2, false)))
            }
        }
        
        if let a = inputs["A"], let b2 = inputs["b2"], let h = inputs["h"] {
            let b1 = a * 2 / h - b2
            result.append(("Upper Base", "A, b1, h", correctToSigFigAndPi(b1, false)))
            if let s1 = inputs["s1"], let s2 = inputs["s2"] {
                result.append(("Perimeter", "A, b2, h, s1, s2", correctToSigFigAndPi(b1 + b2 + s1 + s2, false)))
            }
        }
        
        if result.count == 0 {
            return nil
        } else {
            return result
        }
    }
}