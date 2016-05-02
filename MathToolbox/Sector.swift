import UIKit

class Sector : Operation {
    var operationName: String {
        return "Sectors"
    }
    
    var operationAvailableInputs: [(name: String, desc: String)] {
        return [
            ("r", "The radius of the sector"),
            ("θ", "The angle at the center, in ANGLE_MEASURE"),
            ("A", "The area of the sector")
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
            result.append(("Area", "r, θ", correctToSigFigAndPi(UserSettings.valueOfPi * r * r * (θ / (UserSettings.pref180Degrees * 2)), true)))
        }
        
        if let r = inputs["r"], let a = inputs["A"] {
            result.append(("Angle at the Center", "r, a", correctToSigFigAndPi((a * UserSettings.pref180Degrees * 2) / (r * UserSettings.valueOfPi * r), true)))
        }
        
        if let θ = inputs["θ"], let a = inputs["A"] {
            result.append(("Radius", "θ, a", correctToSigFigAndPi(sqrt(a / (θ / (UserSettings.pref180Degrees * 2)) / UserSettings.valueOfPi), true)))
        }
        
        if result.count == 0 {
            return nil
        } else {
            return result
        }
    }

}