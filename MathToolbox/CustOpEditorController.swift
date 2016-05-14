import UIKit
import TableViewModel
import MGSwipeTableCell
import CoreData

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
        
        section2.headerTitle = NSLocalizedString("Available Inputs", comment: "")
        tbModel.addSection(section2)
        
        let section3 = TableSection()
        
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
        
        section3.headerTitle = NSLocalizedString("Results", comment: "")
        tbModel.addSection(section3)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        var listOfInputNames = [UITextField]()
        txtInputs.forEach { listOfInputNames.append($0.0) }
        if listOfInputNames.contains(textField) {
            if let symbol = CustOpEditorUtils.symbolsDict[textField.text!] {
                textField.text = symbol
            }
        }
    }
    
    func showError(errStr: String) {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString(errStr, comment: ""), preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        var shouldReturn = false
        txtInputs.forEach {
            tuple in
            if tuple.0.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" || tuple.1.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
                shouldReturn = true
            }
        }
        
        if shouldReturn {
            self.showError("Please fill in all the blanks")
            return
        }
        
        txtResults.forEach {
            tuple in
            if tuple.0.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" || tuple.1.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
                shouldReturn = true
            }

        }
        
        if shouldReturn {
            self.showError("Please fill in all the blanks")
            return
        }
        
        if txtName.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
            self.showError("Please fill in all the blanks")
            return
        }
        
        if txtInputs.isEmpty {
            self.showError("Please add at least one input")
            return
        }
        
        if txtResults.isEmpty {
            self.showError("Please add at least one result")
        }
        
        txtInputs.forEach {
            tuple in
            if tuple.0.text?.characters.count > 2 {
                shouldReturn = true
            }
        }
        
        if shouldReturn {
            self.showError("Input names cannot be longer than 2 characters")
            return
        }
        
        txtInputs.forEach {
            tuple in
            let txt = tuple.0.text!
            if txt.containsString(" ") || txt.containsString("'") || txt.containsString("$") {
                shouldReturn = true
            }
        }
        
        if shouldReturn {
            self.showError("Input names cannot contain spaces, single quotes, or dollar signs")
            return
        }
        
        for (_, formula) in txtResults {
            if countCharatcersInString(formula.text!, c: "'") % 2 == 1 || countCharatcersInString(formula.text!, c: "(") != countCharatcersInString(formula.text!, c: ")") {
                self.showError("Parentheses and quotes must be balanced in formulas")
                return
            } else if formula.text!.containsString("$") {
                self.showError("Formulas cannot contain dollar signs")
                return
            }
        }
        
        let mappedInputNames = txtInputs.map { $0.0.text! }
        
        if Set<String>(mappedInputNames).count != mappedInputNames.count {
            self.showError("Input names must not contain duplicates")
            return
        }
        
        let dataContext: NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        let entityOp = NSEntityDescription.entityForName("OperationEntity", inManagedObjectContext: dataContext)!
        let entityInput = NSEntityDescription.entityForName("OperationInput", inManagedObjectContext: dataContext)
        let entityResult = NSEntityDescription.entityForName("OperationResult", inManagedObjectContext: dataContext)
        
        var objToSave: OperationEntity!
        if operationEntity != nil {
            for input in operationEntity!.availableInputs! {
                dataContext.deleteObject(input as! NSManagedObject)
            }
            
            for result in operationEntity!.results! {
                dataContext.deleteObject(result as! NSManagedObject)
            }
            objToSave = operationEntity
            objToSave.name = txtName.text!
            objToSave.rejectFloatingPoint = switchRejectFloatingPoint.on
        } else {
            objToSave = OperationEntity(entity: entityOp, insertIntoManagedObjectContext: dataContext, name: txtName.text!, rejectFloatingPoint: switchRejectFloatingPoint.on)
        }
        
        var inputArr = [OperationInput]()
        for (name, desc) in txtInputs {
            let input = OperationInput(entity: entityInput!, insertIntoManagedObjectContext: dataContext, name: name.text!, desc: desc.text!, operation: objToSave)
            inputArr.append(input)
        }
        objToSave.availableInputs = NSSet(array: inputArr)
        
        var resultArr = [OperationResult]()
        for (name, formula) in txtResults {
            let result = OperationResult(entity: entityResult!, insertIntoManagedObjectContext: dataContext, formula: formula.text!, name: name.text!, operation: objToSave)
            resultArr.append(result)
        }
        objToSave.results = NSSet(array: resultArr)
        
        dataContext.saveData()
        performSegueWithIdentifier("custOpSaved", sender: self)
    }
}

func countCharatcersInString(str: String, c: Character) -> Int {
    var counter = 0
    for char in str.characters {
        if char == c {
            counter += 1
        }
    }
    return counter
}