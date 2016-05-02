import UIKit

class Circle: Operation {
    var operationName: String {
        return "Circle"
    }
    
    var operationAvailableInputs: [(name: String, desc: String)] {
        return [
            ("r", "Radius of the circle"),
            ("d", "Diameter of the circle"),
            ("P", "Perimeter of the circle"),
            ("A", "Area of the circle")
            ]
    }
    
    var operationRejectFloatingPoint: Bool {
        get {return false}
    }
    
    var operationImage: UIImage? {
        return nil
    }
    
    func calculate(inputs: [String : Double]) -> [(name: String, from: String, result: String)]? {
        if inputs.count == 0 {
            return nil
        }
        
        var result: [(name: String, from: String, result: String)] = []
        if let r = inputs["r"] {
            let p = r * UserSettings.valueOfPi * 2
            let a = r * r * UserSettings.valueOfPi
            let d = r * 2
            result.append(("Diameter", "r", correctToSigFigAndPi(d, false)))
            result.append(("Perimeter", "r", correctToSigFigAndPi(p, true)))
            result.append(("Area", "r", correctToSigFigAndPi(a, true)))
        }
        
        if let d = inputs["d"] {
            result.append(("Radius", "d", correctToSigFigAndPi(d / 2.0, false)))
            result.append(("Perimeter", "d", correctToSigFigAndPi(d * UserSettings.valueOfPi, true)))
            result.append(("Area", "d", correctToSigFigAndPi(pow(d / 2.0, 2.0) * UserSettings.valueOfPi, true)))
        }
        
        if let p = inputs["P"] {
            result.append(("Radius", "P", correctToSigFigAndPi(p / (2.0 * UserSettings.valueOfPi), true)))
            result.append(("Diameter", "P", correctToSigFigAndPi(p / UserSettings.valueOfPi, true)))
            result.append(("Area", "P", correctToSigFigAndPi(pow(p / (2 * UserSettings.valueOfPi), 2) * UserSettings.valueOfPi, true)))
        }
        
        if let a = inputs["A"] {
            result.append(("Radius", "A", correctToSigFigAndPi(sqrt(a / UserSettings.valueOfPi), true)))
            result.append(("Diameter", "A", correctToSigFigAndPi(sqrt(a / UserSettings.valueOfPi) * 2, true)))
            result.append(("Perimeter", "A", correctToSigFigAndPi(sqrt(a / UserSettings.valueOfPi) * 2 * UserSettings.valueOfPi, true)))
        }
        
        if result.count == 0 {
            return nil
        } else {
            return result
        }
    }
}
