import UIKit

protocol Operation {
    var operationName: String { get }
    var operationAvailableInputs: [(name: String, desc: String)] { get }
    var operationRejectFloatingPoint: Bool { get }
    var operationImage: UIImage? { get }
    
    func calculate (inputs: [String: Double]) -> [(name: String, from: String, result: String)]?
}

func correctToSigFigAndPi(x: Double, _ containsPi: Bool) -> String {
    var num = x
    num = UserSettings.sigFigOption.correctTo(num)
    if containsPi && UserSettings.usePiLiteral {
        num /= UserSettings.valueOfPi
        return String(num) + "π"
    }
    return String(num)
}