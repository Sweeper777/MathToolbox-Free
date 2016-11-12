import UIKit

class Triangle: Operation {
    var operationName: String {
        return "Triangle"
    }
    
    var operationAvailableInputs: [(name: String, desc: String)] {
        return [
            ("b", "The base of the triangle"),
            ("h", "The height of the triangle"),
            ("s1", "The side length of the triangle"),
            ("s2", "The side length of the triangle"),
            ("s3", "The side length of the triangle"),
            ("P", "The perimeter of the triangle"),
            ("A", "The area of the triangle")
        ]
    }
    
    var operationRejectFloatingPoint: Bool { return false }
    var operationImage: UIImage? { return UIImage(named: "triangle") }
    
    func calculate(inputs: [String : Double]) -> [(name: String, from: String, result: String)]? {
        if inputs.count == 0 {
            return nil
        }
        
        var result: [(name: String, from: String, result: String)] = []
        
        if let b = inputs["b"], let h = inputs["h"] {
            result.append(("Area", "b, h", correctToSigFigAndPi(b * h / 2.0, false)))
        }
        
        if let b = inputs["b"], let a = inputs["A"] {
            result.append(("Height", "b, A", correctToSigFigAndPi(a * 2 / b, false)))
        }
        
        if let h = inputs["h"], let a = inputs["A"] {
            result.append(("Base", "h, A", correctToSigFigAndPi(a * 2 / h, false)))
        }
        
        if let s1 = inputs["s1"], let s2 = inputs["s2"], let s3 = inputs["s3"] {
            result.append(("Perimeter", "s1, s2, s3", correctToSigFigAndPi(s1 + s2 + s3, false)))
            if s1 == s2 && s2 == s3 {
                result.append(("Area", "s1, s2, s3", correctToSigFigAndPi(sqrt(3) * s1 * s1 / 4.0, false)))
            }
            
            let a = s1, b = s2, c = s3
            
            if a * a + b * b == c * c || a * a + c * c == b * b || b * b + c * c == a * a {
                result.append(("Is Right Angled", "a, b, c", NSLocalizedString("True", comment: "")))
                let sorted = [a, b, c].sorted()
                let area = sorted[0] * sorted[1] / 2
                
                result.append(("Area", "a, b, c", correctToSigFigAndPi(area, false)))
            } else {
                result.append(("Is Right Angled", "a, b , c", NSLocalizedString("False", comment: "")))
            }
            
        } else {
            if let s1 = inputs["s1"], let s2 = inputs["s2"], let p = inputs["P"] {
                result.append(("Side Length", "s1, s2, P", correctToSigFigAndPi(p - s1 - s2, false)))
            } else if let s1 = inputs["s1"], let s3 = inputs["s3"], let p = inputs["P"] {
                result.append(("Side Length", "s1, s3, P", correctToSigFigAndPi(p - s1 - s3, false)))
            } else if let s3 = inputs["s3"], let s2 = inputs["s2"], let p = inputs["P"] {
                result.append(("Side Length", "s2, s3, P", correctToSigFigAndPi(p - s3 - s2, false)))
            }
        }
        
        if result.count == 0 {
            return nil
        } else {
            return result
        }
    }

    private func getAdjSides(s1: Double, s2: Double, s3: Double) -> (Double, Double)? {
        let maxNum = max(s1, s2, s3)
        if maxNum == s1 && (s1 * s1 == s2 * s2 + s3 * s3) {
            return (s2, s3)
        }
        
        if maxNum == s2 && (s2 * s2 == s1 * s1 + s3 * s3) {
            return (s1, s3)
        }
        
        if maxNum == s3 && (s3 * s3 == s2 * s2 + s1 * s1) {
            return (s1, s2)
        }
        
        return nil
    }
}
