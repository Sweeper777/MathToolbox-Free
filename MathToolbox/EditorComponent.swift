import UIKit

class EditorComponent: UITextFieldDelegate {
    let name: String?
    let rejectFloatingPoint: Bool?
    let buttonText: String?
    let secondaryField: String?
    
    init(component: EditorComponents) {
        
        switch component {
        case .SingleField(let s):
            name = s
            rejectFloatingPoint = nil
            buttonText = nil
            secondaryField = nil
        case .DoubleField(let s1, let s2):
            name = s1
            secondaryField = s2
            rejectFloatingPoint = nil
            buttonText = nil
        case .Button(let s):
            buttonText = s
            name = nil
            rejectFloatingPoint = nil
            secondaryField = nil
        case .Switch(let b):
            rejectFloatingPoint = b
            buttonText = nil
            secondaryField = nil
            name = nil
        }
    }
}

enum EditorComponents {
    case SingleField(String)
    case DoubleField(String, String)
    case Button(String)
    case Switch(Bool)
}
