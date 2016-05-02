import UIKit

class Arc : Operation {
    var operationName: String {
        return "Arcs"
    }
    
    var operationAvailableInputs: [(name: String, desc: String)] {
        return [
            ("r", "The radius of the arc"),
            ("θ", "The angle at the center, in ANGLE_MEASURE"),
            ("a", "The arc length")
        ]
    }
    
    var operationRejectFloatingPoint: Bool { return false }
    var operationImage: UIImage? { return nil }
    
    func calculate(inputs: [String : Double]) -> [(name: String, from: String, result: String)]? {
        if inputs.count == 0 {
            return nil
        }
        
        var result: [(name: String, from: String, result: String)] = []
        
        if let r = inputs["r"], let θ = inputs["θ"] {
            result.append(("Arc Length", "r, θ", correctToSigFigAndPi(2 * UserSettings.valueOfPi * r * (θ / (UserSettings.pref180Degrees * 2)), true)))
        }
        
        if let r = inputs["r"], let a = inputs["a"] {
            result.append(("Angle at the Center", "r, a", correctToSigFigAndPi((a * UserSettings.pref180Degrees * 2) / (2 * UserSettings.valueOfPi * r), true)))
        }
        
        if let θ = inputs["θ"], let a = inputs["a"] {
            result.append(("Radius", "θ, a", correctToSigFigAndPi(a / (θ / (UserSettings.pref180Degrees * 2)) / (2 * UserSettings.valueOfPi), true)))
        }
        
        if result.count == 0 {
            return nil
        } else {
            return result
        }
    }
}