import UIKit
import MathParser

class Trigonometry: Operation {
    var operationName: String {
        return "Trigonometry"
    }
    
    var operationAvailableInputs: [(name: String, desc: String)] {
        return [
            ("x", "The trigonometric function parameter")
        ]
    }
    
    var operationRejectFloatingPoint: Bool { return false }
    var operationImage: UIImage? { return nil }
    
    func calculate(inputs: [String : Double]) -> [(name: String, from: String, result: String)]? {
        if inputs.count == 0 {
            return nil
        }
        
        var result: [(name: String, from: String, result: String)] = []
        
        if let x = inputs["x"] {
            // normal stuff
            result.append(("sin(x)", "x", correctToSigFigAndPi(evaluate("sin(\(UserSettings.convertFromPref(x)))"), false)))
            result.append(("cos(x)", "x", correctToSigFigAndPi(evaluate("cos(\(UserSettings.convertFromPref(x)))"), false)))
            result.append(("tan(x)", "x", correctToSigFigAndPi(evaluate("tan(\(UserSettings.convertFromPref(x)))"), false)))
            result.append(("sin⁻¹(x)", "x", correctToSigFigAndPi(UserSettings.convertToPref(evaluate("asin(\(x))")), false)))
            result.append(("cos⁻¹(x)", "x", correctToSigFigAndPi(UserSettings.convertToPref(evaluate("acos(\(x))")), false)))
            result.append(("tan⁻¹(x)", "x", correctToSigFigAndPi(UserSettings.convertToPref(evaluate("atan(\(x))")), false)))
            result.append(("csc(x)", "x", correctToSigFigAndPi(evaluate("csc(\(UserSettings.convertFromPref(x)))"), false)))
            result.append(("sec(x)", "x", correctToSigFigAndPi(evaluate("sec(\(UserSettings.convertFromPref(x)))"), false)))
            result.append(("cot(x)", "x", correctToSigFigAndPi(evaluate("cotan(\(UserSettings.convertFromPref(x)))"), false)))
            result.append(("csc⁻¹(x)", "x", correctToSigFigAndPi(UserSettings.convertToPref(evaluate("acsc(\(x))")), false)))
            result.append(("sec⁻¹(x)", "x", correctToSigFigAndPi(UserSettings.convertToPref(evaluate("asec(\(x))")), false)))
            result.append(("cot⁻¹(x)", "x", correctToSigFigAndPi(UserSettings.convertToPref(evaluate("acotan(\(x))")), false)))
            
            // Hyperbolic
            result.append(("sinh(x)", "x", correctToSigFigAndPi(evaluate("sinh(\(UserSettings.convertFromPref(x)))"), false)))
            result.append(("cosh(x)", "x", correctToSigFigAndPi(evaluate("cosh(\(UserSettings.convertFromPref(x)))"), false)))
            result.append(("tanh(x)", "x", correctToSigFigAndPi(evaluate("tanh(\(UserSettings.convertFromPref(x)))"), false)))
            result.append(("sinh⁻¹(x)", "x", correctToSigFigAndPi(UserSettings.convertToPref(evaluate("asinh(\(x))")), false)))
            result.append(("cosh⁻¹(x)", "x", correctToSigFigAndPi(UserSettings.convertToPref(evaluate("acosh(\(x))")), false)))
            result.append(("tanh⁻¹(x)", "x", correctToSigFigAndPi(UserSettings.convertToPref(evaluate("atanh(\(x))")), false)))
            result.append(("csch(x)", "x", correctToSigFigAndPi(evaluate("csch(\(UserSettings.convertFromPref(x)))"), false)))
            result.append(("sech(x)", "x", correctToSigFigAndPi(evaluate("sech(\(UserSettings.convertFromPref(x)))"), false)))
            result.append(("coth(x)", "x", correctToSigFigAndPi(evaluate("cotanh(\(UserSettings.convertFromPref(x)))"), false)))
            result.append(("csch⁻¹(x)", "x", correctToSigFigAndPi(UserSettings.convertToPref(evaluate("acsch(\(x))")), false)))
            result.append(("sech⁻¹(x)", "x", correctToSigFigAndPi(UserSettings.convertToPref(evaluate("asech(\(x))")), false)))
            result.append(("coth⁻¹(x)", "x", correctToSigFigAndPi(UserSettings.convertToPref(evaluate("acotanh(\(x))")), false)))
        }
        
        if result.count == 0 {
            return nil
        } else {
            return result
        }
    }
    
    var description: String? = "This operation shows the results of different trigonometric functions."
    
    func evaluate(_ exp: String) -> Double {
        var eval = Evaluator()
        eval.angleMeasurementMode = .radians
        return try! eval.evaluate(Expression(string: exp))
    }
}
