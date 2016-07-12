import UIKit
import DTModelStorage
import DTTableViewManager

class EditorComponentCell: UITableViewCell, ModelTransfer {
    func updateWithModel(model: EditorComponents) {
        switch model {
        case .SingleField(let field):
            self.addSubview(field)
            self.selectionStyle = .None
        case .DoubleField(let field1, let field2):
            self.addSubview(field1)
            self.addSubview(field2)
            self.selectionStyle = .None
        case .Button(let btn):
            self.addSubview(btn)
            self.selectionStyle = .Gray
        case .Switch(let lbl, let sw):
            self.addSubview(lbl)
            self.addSubview(sw)
            self.selectionStyle = .None
        }
    }
}

enum EditorComponents {
    case SingleField(UITextField)
    case DoubleField(UITextField, UITextField)
    case Button(UILabel)
    case Switch(UILabel, UISwitch)
}
