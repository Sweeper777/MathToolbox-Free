import UIKit

class TimeInterval : Operation {
    var operationName: String {
        return "Time Interval"
    }
    
    var operationAvailableInputs: [(name: String, desc: String)] {
        return [
            ("h", "Number of hours"),
            ("m", "Number of minutes"),
            ("s", "Number of seconds")
        ]
    }
    
    var operationRejectFloatingPoint: Bool { return false }
    var operationImage: UIImage? { return nil }
    
    func calculate(inputs: [String : Double]) -> [(name: String, from: String, result: String)]? {
        if inputs.count == 0 {
            return nil
        }
        
        var result: [(name: String, from: String, result: String)] = []
        
        if let h = inputs["h"] {
            let m = h * 60.0
            let s = m * 60.0
            result.append(("Minutes", "h", correctToSigFigAndPi(m, false)))
            result.append(("Seconds", "h", correctToSigFigAndPi(s, false)))
            
            result.append(("Normalized Form", "h", normalizeTimeInterval(s: s)))
        }
        
        if let m = inputs["m"] {
            let h = m / 60.0
            let s = m * 60.0
            result.append(("Hours", "m", correctToSigFigAndPi(h, false)))
            result.append(("Seconds", "m", correctToSigFigAndPi(s, false)))
            
            result.append(("Normalized Form", "m", normalizeTimeInterval(s: s)))
        }
        
        if let s = inputs["s"] {
            let m = s / 60.0
            let h = m / 60.0
            result.append(("Hours", "s", correctToSigFigAndPi(h, false)))
            result.append(("Minutes", "s", correctToSigFigAndPi(m, false)))
            
            result.append(("Normalized Form", "s", normalizeTimeInterval(s: s)))
        }
        
        if result.count == 0 {
            return nil
        } else {
            return result
        }
    }
    
    private func normalizeTimeInterval(s: Foundation.TimeInterval) -> String {
        let days = Int(s) / 86400
        let hours = Int(s) % 86400 / 60 / 60
        let minutes = Int(s) % 3600 / 60
        let seconds = Int(s) % 60
        
        var normalized = ""
        
        if days == 1 {
            normalized += "\(days) \(NSLocalizedString("Day", comment: "")) "
        } else if days != 0 {
            normalized += "\(days) \(NSLocalizedString("Days", comment: "")) "
        }
        
        if hours == 1 {
            normalized += "\(hours) \(NSLocalizedString("Hour", comment: "")) "
        } else if hours != 0 {
            normalized += "\(hours) \(NSLocalizedString("Hours", comment: "")) "
        }
        
        if minutes == 1 {
            normalized += "\(minutes) \(NSLocalizedString("Minute", comment: "")) "
        } else if minutes != 0 {
            normalized += "\(minutes) \(NSLocalizedString("Minutes", comment: "")) "
        }
        
        if seconds == 1 {
            normalized += "\(seconds) \(NSLocalizedString("Second", comment: "")) "
        } else if seconds != 0 {
            normalized += "\(seconds) \(NSLocalizedString("Seconds", comment: "")) "
        }
        
        return normalized
    }
}
