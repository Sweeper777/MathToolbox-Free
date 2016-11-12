import UIKit

class TrigAndPyth : Operation {
    var operationName: String {
        return "Trigonometry & Pythagoras Theorem"
    }
    
    var operationAvailableInputs: [(name: String, desc: String)] {
        return [
            ("a", "Refer to figure"),
            ("b", "Refer to figure"),
            ("c", "Refer to figure"),
            ("θa", "Refer to figure, angle in ANGLE_MEASURE"),
            ("θb", "Refer to figure, angle in ANGLE_MEASURE")
        ]
    }
    
    var operationRejectFloatingPoint: Bool { return false }
    var operationImage: UIImage? { return UIImage(named: "trig") }
    
    func calculate(inputs: [String : Double]) -> [(name: String, from: String, result: String)]? {
        if inputs.count == 0 {
            return nil
        }
        
        var result: [(name: String, from: String, result: String)] = []
        
        if let c = inputs["c"], let a = inputs["a"] {
            result.append(("b", "a, c", correctToSigFigAndPi(pythTheorm(a: a, b: nil, c: c)!, false)))
            result.append(("θa", "a, c", correctToSigFigAndPi(UserSettings.convertToPref(acos(a / c)), false)))
            result.append(("θb", "a, c", correctToSigFigAndPi(UserSettings.convertToPref(asin(a / c)), false)))
        }
        
        if let a = inputs["a"], let b = inputs["b"] {
            result.append(("c", "a, b", correctToSigFigAndPi(pythTheorm(a: a, b: b, c: nil)!, false)))
            result.append(("θa", "a, b", correctToSigFigAndPi(UserSettings.convertToPref(atan(b / a)), false)))
            result.append(("θb", "a, b", correctToSigFigAndPi(UserSettings.convertToPref(atan(a / b)), false)))
        }
        
        if let b = inputs["b"], let c = inputs["c"] {
            result.append(("a", "b, c", correctToSigFigAndPi(pythTheorm(a: nil, b: b, c: c)!, false)))
            result.append(("θa", "b, c", correctToSigFigAndPi(UserSettings.convertToPref(asin(b / c)), false)))
            result.append(("θb", "b, c", correctToSigFigAndPi(UserSettings.convertToPref(acos(b / c)), false)))
        }
        
        if let θa = inputs["θa"] {
            result.append(("θb", "θa", correctToSigFigAndPi(UserSettings.pref90Degrees - θa, false)))
            if let a = inputs["a"] {
                let c = a / cos(UserSettings.convertFromPref(θa))
                result.append(("c", "θa, a", correctToSigFigAndPi(c, false)))
                result.append(("b", "θa, a", correctToSigFigAndPi(pythTheorm(a: a, b: nil, c: c)!, false)))
            }
            
            if let b = inputs["b"] {
                let c = b / sin(UserSettings.convertFromPref(θa))
                result.append(("c", "θa, b", correctToSigFigAndPi(c, false)))
                result.append(("a", "θa, b", correctToSigFigAndPi(pythTheorm(a: nil, b: b, c: c)!, false)))
            }
            
            if let c = inputs["c"] {
                let b = c * sin(UserSettings.convertFromPref(θa))
                result.append(("b", "θa, c", correctToSigFigAndPi(b, false)))
                result.append(("a", "θa, c", correctToSigFigAndPi(pythTheorm(a: nil, b: b, c: c)!, false)))
            }
        }
        
        if let θb = inputs["θb"] {
            result.append(("θa", "θb", correctToSigFigAndPi(UserSettings.pref90Degrees - θb, false)))
            if let a = inputs["a"] {
                let c = a / sin(UserSettings.convertFromPref(θb))
                result.append(("c", "θb, a", correctToSigFigAndPi(c, false)))
                result.append(("b", "θb, a", correctToSigFigAndPi(pythTheorm(a: a, b: nil, c: c)!, false)))
            }
            
            if let b = inputs["b"] {
                let c = b / cos(UserSettings.convertFromPref(θb))
                result.append(("c", "θb, b", correctToSigFigAndPi(c, false)))
                result.append(("a", "θb, b", correctToSigFigAndPi(pythTheorm(a: nil, b: b, c: c)!, false)))
            }
            
            if let c = inputs["c"] {
                let b = c * cos(UserSettings.convertFromPref(θb))
                result.append(("b", "θb, c", correctToSigFigAndPi(b, false)))
                result.append(("a", "θb, c", correctToSigFigAndPi(pythTheorm(a: nil, b: b, c: c)!, false)))
            }
        }
        
        if result.count == 0 {
            return nil
        } else {
            return result
        }
    }
}

func pythTheorm(a: Double?, b: Double?, c: Double?) -> Double? {
    if let A = a, let B = b {
        return sqrt(A * A + B * B)
    }
    
    if let B = b, let C = c {
        return sqrt(C * C - B * B)
    }
    
    if let A = a, let C = c {
        return sqrt(C * C - A * A)
    }
    
    return nil
}
