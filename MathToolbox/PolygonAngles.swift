import UIKit

class PolygonAngles : Operation {
    var operationName: String {
        return "Angles of Polygons"
    }
    
    var operationAvailableInputs: [(name: String, desc: String)] {
        return [
            ("n", "Number of interior angles of the polygon (Please enter an integer in this blank. Other forms of input will be ignored)"),
            ("θ", "Sum of all interior angles of the polygon, in ANGLE_MEASURE"),
            ("θ'", "The size of each interior angle of the polygon, in ANGLE_MEASURE (This is only applicable when the polygon is a regular polygon)"),
            ("θe", "Size of each exterior angle of the polygon, in ANGLE_MEASURE (This is only applicable when the polygon is a regular polygon)")
        ]
    }
    
    var operationRejectFloatingPoint: Bool { return false }
    var operationImage: UIImage? { return nil }
    
    func calculate(inputs: [String : Double]) -> [(name: String, from: String, result: String)]? {
        if inputs.count == 0 {
            return nil
        }
        
        var result: [(name: String, from: String, result: String)] = []
        
        if let n = inputs["n"] {
            let θ = (n - 2) * UserSettings.pref180Degrees
            result.append(("Sum of Interior Angles", "n", correctToSigFigAndPi(θ, false)))
            result.append(("Each Interior Angle (if regular)", "n", correctToSigFigAndPi(θ / n, false)))
            result.append(("Each Exterior Angle (if regular)", "n", correctToSigFigAndPi(UserSettings.pref180Degrees * 2 / n, false)))
        }
        
        if let θ = inputs["θ"] {
            if let n = Int(String(θ / UserSettings.pref180Degrees + 2)) {
                result.append(("Number of Angles (if regular)", "θ", correctToSigFigAndPi(Double(n), false)))
                result.append(("Each Interior Angle (if regular)", "θ", correctToSigFigAndPi(θ / Double(n), false)))
                result.append(("Each Exterior Angle (if regular)", "θ", correctToSigFigAndPi(UserSettings.pref180Degrees * 2 / Double(n), false)))
            }
        }
        
        if let θ1 = inputs["θ'"] {
            if let n = Int(String(-UserSettings.pref180Degrees * 2 / (θ1 - 180))) {
                result.append(("Number of Angles (if regular)", "θ'", correctToSigFigAndPi(Double(n), false)))
                result.append(("Sum of Interior Angles (if regular)", "θ'", correctToSigFigAndPi(θ1 * Double(n), false)))
                result.append(("Each Exterior Angle (if regular)", "θ'", correctToSigFigAndPi(UserSettings.pref180Degrees * 2 / Double(n), false)))
            }
        }
        
        if let θ2 = inputs["θe"] {
            if let n = Int(String(UserSettings.pref180Degrees * 2 / θ2)) {
                result.append(("Number of Angles (if regular)", "θe", correctToSigFigAndPi(Double(n), false)))
                result.append(("Sum of Interior Angles (if regular)", "θe", correctToSigFigAndPi(Double(n - 2) * UserSettings.pref180Degrees, false)))
                result.append(("Each Interior Angle (if regular)", "θe", correctToSigFigAndPi(Double(n - 2) * UserSettings.pref180Degrees / Double(n), false)))
            }
        }
        
        if result.count == 0 {
            return nil
        } else {
            return result
        }
    }
}