import UIKit

class DegreesRadiansGradians : Operation {
    var operationName: String {
        return "Degrees, Radians, Gradians"
    }
    
    var operationAvailableInputs: [(name: String, desc: String)] {
        return [
            ("d", "Angle in degrees"),
            ("r", "Angle in radians"),
            ("g", "Angle in gradians")
        ]
    }
    
    var operationRejectFloatingPoint: Bool { return false }
    var operationImage: UIImage? { return nil }
    
    func calculate(inputs: [String : Double]) -> [(name: String, from: String, result: String)]? {
        if inputs.count == 0 {
            return nil
        }
        
        var result: [(name: String, from: String, result: String)] = []
        
        if let d = inputs["d"] {
            result.append(("Radians", "d", correctToSigFigAndPi(d * UserSettings.valueOfPi / 180.0, true)))
            result.append(("Gradians", "d", correctToSigFigAndPi(d * (10.0 / 9.0), false)))
        }
        
        if let r = inputs["r"] {
            let d = 180 * r / UserSettings.valueOfPi
            result.append(("Degrees", "r", correctToSigFigAndPi(d, true)))
            result.append(("Gradians", "r", correctToSigFigAndPi(d * (10.0 / 9.0), true)))
        }
        
        if let g = inputs["g"] {
            let d = g / (10.0 / 9.0)
            result.append(("Degrees", "g", correctToSigFigAndPi(d, false)))
            result.append(("Radians", "g", correctToSigFigAndPi(d * UserSettings.valueOfPi / 180.0, true)))
        }
        
        if result.count == 0 {
            return nil
        } else {
            return result
        }
    }
}
