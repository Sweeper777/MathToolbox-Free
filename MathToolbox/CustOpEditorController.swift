import UIKit
import TableViewModel
import MGSwipeTableCell

class CustOpEditorController: UITableViewController, UITextFieldDelegate {
    var tbModel: TableViewModel!
    
    var operationEntity: OperationEntity?
    
    var txtInputs = [(UITextField, UITextField)]()
    var txtResults = [(UITextField, UITextField)]()
    var txtName: UITextField!
    var switchRejectFloatingPoint: UISwitch!
    
    var editingInput = false
    var editingResult = false
    
    override func viewDidLoad() {
        if operationEntity == nil {
            navigationItem.title = NSLocalizedString("New Custom Operation", comment: "")
        } else {
            navigationItem.title = operationEntity!.name!
        }
        
        tbModel = TableViewModel(tableView: self.tableView)
        
        let section1 = TableSection()
        
        var cell = TableRow(cellIdentifier: "normalText")
        cell.configureCell { cell in
            self.txtName = cell.viewWithTag(1) as! UITextField
            self.txtName.placeholder = NSLocalizedString("Name", comment: "")
            self.txtName.text = self.operationEntity?.name ?? ""
            self.txtName.delegate = self
        }
        section1.addRow(cell)
        
        cell = TableRow(cellIdentifier: "switch")
        cell.configureCell { cell in
            self.switchRejectFloatingPoint = cell.viewWithTag(2) as! UISwitch
            self.switchRejectFloatingPoint.on = self.operationEntity?.rejectFloatingPoint?.boolValue ?? false
        }
        section1.addRow(cell)
        
        section1.headerTitle = NSLocalizedString("Basic Information", comment: "")
        tbModel.addSection(section1)
        
        let section2 = TableSection()
        
        if let inputs = operationEntity?.availableInputs {
            for input in inputs {
                let realInput = input as! OperationInput
                cell = TableRow(cellIdentifier: "doubleText")
                cell.configureCell { c in
                    let name = c.viewWithTag(1) as! UITextField
                    let description = c.viewWithTag(2) as! UITextField
                    name.placeholder = NSLocalizedString("Name", comment: "")
                    description.placeholder = NSLocalizedString("Description", comment: "")
                    name.text = realInput.name!
                    description.text = realInput.desc!
                    name.delegate = self
                    description.delegate = self
                    self.txtInputs.append((name, description))
                    
                    let swipeCell = c as! MGSwipeTableCell
                    let deleteBtn = MGSwipeButton(title: NSLocalizedString("Delete", comment: ""), backgroundColor: UIColor.redColor(), callback: { _ in
                        section2.removeRow(cell)
                        self.txtInputs.removeAtIndex(self.txtInputs.indexOf{$0.0 == name && $0.1 == description}!)
                        return true
                    })
                    swipeCell.rightButtons = [deleteBtn]
                }
                section2.addRow(cell)
            }
        }
        
        cell = TableRow(cellIdentifier: "button")
        cell.configureCell { (cell) in
            cell.textLabel!.text = NSLocalizedString("Add New Input", comment: "")
        }
        
        cell.onSelect { (row) in
            let newRow = TableRow(cellIdentifier: "doubleText")
            newRow.configureCell { c in
                let name = c.viewWithTag(1) as! UITextField
                let description = c.viewWithTag(2) as! UITextField
                name.placeholder = NSLocalizedString("Name", comment: "")
                description.placeholder = NSLocalizedString("Description", comment: "")
                name.text = ""
                description.text = ""
                name.delegate = self
                description.delegate = self
                self.txtInputs.append((name, description))
                
                let swipeCell = c as! MGSwipeTableCell
                let deleteBtn = MGSwipeButton(title: NSLocalizedString("Delete", comment: ""), backgroundColor: UIColor.redColor(), callback: { _ in
                    section2.removeRow(newRow)
                    self.txtInputs.removeAtIndex(self.txtInputs.indexOf{$0.0 == name && $0.1 == description}!)
                    return true
                })
                swipeCell.rightButtons = [deleteBtn]
            }

            row.tableSection?.addRow(newRow)
        }
        
        section2.addRow(cell)
        
        section2.headerTitle = NSLocalizedString("Available Inputs", comment: "")
        tbModel.addSection(section2)
        
        let section3 = TableSection()
        
        if let results = operationEntity?.results {
            for result in results {
                let realResult = result as! OperationResult
                cell = TableRow(cellIdentifier: "doubleText")
                cell.configureCell { c in
                    let name = c.viewWithTag(1) as! UITextField
                    let formula = c.viewWithTag(2) as! UITextField
                    name.placeholder = NSLocalizedString("Name", comment: "")
                    formula.placeholder = NSLocalizedString("Formula", comment: "")
                    name.text = realResult.name!
                    formula.text = realResult.formula!
                    name.delegate = self
                    formula.delegate = self
                    self.txtResults.append((name, formula))
                    
                    let swipeCell = c as! MGSwipeTableCell
                    let deleteBtn = MGSwipeButton(title: NSLocalizedString("Delete", comment: ""), backgroundColor: UIColor.redColor(), callback: { _ in
                        section3.removeRow(cell)
                        self.txtResults.removeAtIndex(self.txtResults.indexOf{$0.0 == name && $0.1 == formula}!)
                        return true
                    })
                    swipeCell.rightButtons = [deleteBtn]
                }
                section3.addRow(cell)
            }
        }
        
        cell = TableRow(cellIdentifier: "button")
        cell.configureCell { (cell) in
            cell.textLabel!.text = NSLocalizedString("Add New Result", comment: "")
        }
        
        cell.onSelect { (row) in
            let newRow = TableRow(cellIdentifier: "doubleText")
            newRow.configureCell { c in
                let name = c.viewWithTag(1) as! UITextField
                let formula = c.viewWithTag(2) as! UITextField
                name.placeholder = NSLocalizedString("Name", comment: "")
                formula.placeholder = NSLocalizedString("Formula", comment: "")
                name.text = ""
                formula.text = ""
                name.delegate = self
                formula.delegate = self
                self.txtResults.append((name, formula))
                
                let swipeCell = c as! MGSwipeTableCell
                let deleteBtn = MGSwipeButton(title: NSLocalizedString("Delete", comment: ""), backgroundColor: UIColor.redColor(), callback: { _ in
                    section3.removeRow(newRow)
                    self.txtResults.removeAtIndex(self.txtResults.indexOf{$0.0 == name && $0.1 == formula}!)
                    return true
                })
                swipeCell.rightButtons = [deleteBtn]
            }
            
            row.tableSection?.addRow(newRow)
        }
        
        section3.addRow(cell)
        
        section3.headerTitle = NSLocalizedString("Results", comment: "")
        tbModel.addSection(section3)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}