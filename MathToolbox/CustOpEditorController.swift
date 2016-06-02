import UIKit
import MGSwipeTableCell
import CoreData
import JVFloatLabeledTextField

// (╯°□°）╯︵ ┻━┻ Oh... sad memories...
class CustOpEditorController: UITableViewController, UITextFieldDelegate {
    var cells: [[UITableViewCell]] = [[], [], []]
    
    var operationEntity: OperationEntity?
    
    var txtInputs = [(JVFloatLabeledTextField, JVFloatLabeledTextField)]()
    var txtResults = [(JVFloatLabeledTextField, JVFloatLabeledTextField)]()
    var txtName: JVFloatLabeledTextField!
    var switchRejectFloatingPoint: UISwitch!
    
    var editingInput = false
    var editingResult = false
    
    override func viewDidLoad() {
        if operationEntity == nil {
            navigationItem.title = NSLocalizedString("New Custom Operation", comment: "")
        } else {
            navigationItem.title = operationEntity!.name!
        }
        
        let cell1 = tableView.dequeueReusableCellWithIdentifier("normalText")!
        
        self.txtName = cell1.viewWithTag(1) as! JVFloatLabeledTextField
        self.txtName.setPlaceholder(NSLocalizedString("Name", comment: ""), floatingTitle: NSLocalizedString("Name", comment: ""))
        self.txtName.text = self.operationEntity?.name ?? ""
        self.txtName.delegate = self
        
        addCellToSection(0, cell: cell1)

        let cell2 = tableView.dequeueReusableCellWithIdentifier("switch")!
        
        self.switchRejectFloatingPoint = cell2.viewWithTag(2) as! UISwitch
        self.switchRejectFloatingPoint.on = self.operationEntity?.rejectFloatingPoint?.boolValue ?? false
        
        addCellToSection(0, cell: cell2)
        
        let cell3 = tableView.dequeueReusableCellWithIdentifier("button")!
        cell3.textLabel!.text = NSLocalizedString("Add New Input", comment: "")
        
        addCellToSection(1, cell: cell3)
        
        if let inputs = operationEntity?.availableInputs {
            for input in inputs {
                let realInput = input as! OperationInput
                let cell4 = tableView.dequeueReusableCellWithIdentifier("doubleText")!
                
                let name = cell4.viewWithTag(1) as! JVFloatLabeledTextField
                let description = cell4.viewWithTag(2) as! JVFloatLabeledTextField
                name.setPlaceholder(NSLocalizedString("Name", comment: ""), floatingTitle: NSLocalizedString("Name", comment: ""))
                description.setPlaceholder(NSLocalizedString("Description", comment: ""), floatingTitle: NSLocalizedString("Description", comment: ""))
                name.text = realInput.name!
                description.text = realInput.desc!
                name.delegate = self
                description.delegate = self
                self.txtInputs.append((name, description))
                
                let swipeCell = cell4 as! MGSwipeTableCell
                let deleteBtn = MGSwipeButton(title: NSLocalizedString("Delete", comment: ""), backgroundColor: UIColor.redColor(), callback: { _ in
                    let cellIndex = self.cells.indicesOf(swipeCell)!.1
                    self.removeCellFromSection(1, index: cellIndex)
                    self.txtInputs.removeAtIndex(cellIndex - 1)
                    return true
                })
                swipeCell.rightButtons = [deleteBtn]
                
                addCellToSection(1, cell: cell4)
            }
        }
        
        let cell5 = tableView.dequeueReusableCellWithIdentifier("button")!
        
        cell5.textLabel!.text = NSLocalizedString("Add New Result", comment: "")
        
        addCellToSection(2, cell: cell5)
        
        if let results = operationEntity?.results {
            for result in results {
                let realResult = result as! OperationResult
                let cell6 = tableView.dequeueReusableCellWithIdentifier("doubleText")!
                
                    let name = cell6.viewWithTag(1) as! JVFloatLabeledTextField
                    let formula = cell6.viewWithTag(2) as! JVFloatLabeledTextField
                    name.setPlaceholder(NSLocalizedString("Name", comment: ""), floatingTitle: NSLocalizedString("Name", comment: ""))
                    formula.setPlaceholder(NSLocalizedString("Formula", comment: ""), floatingTitle: NSLocalizedString("Formula", comment: ""))
                    name.text = realResult.name!
                    formula.text = realResult.formula!
                    name.delegate = self
                    formula.delegate = self
                    self.txtResults.append((name, formula))
                    
                    let swipeCell = cell6 as! MGSwipeTableCell
                    let deleteBtn = MGSwipeButton(title: NSLocalizedString("Delete", comment: ""), backgroundColor: UIColor.redColor(), callback: { _ in
                        let cellIndex = self.cells.indicesOf(swipeCell)!.1
                        self.removeCellFromSection(2, index: cellIndex)
                        self.txtResults.removeAtIndex(cellIndex)
                        return true
                    })
                    swipeCell.rightButtons = [deleteBtn]
                
                addCellToSection(2, cell: cell6)
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cells.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.section][indexPath.row]
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("Basic Information", comment: "")
        case 1:
            return NSLocalizedString("Available Inputs", comment: "")
        case 2:
            return NSLocalizedString("Results", comment: "")
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            let newRow = tableView.dequeueReusableCellWithIdentifier("doubleText")!
            
            let name = newRow.viewWithTag(1) as! JVFloatLabeledTextField
            let description = newRow.viewWithTag(2) as! JVFloatLabeledTextField
            name.setPlaceholder(NSLocalizedString("Name", comment: ""), floatingTitle: NSLocalizedString("Name", comment: ""))
            description.setPlaceholder(NSLocalizedString("Description", comment: ""), floatingTitle: NSLocalizedString("Description", comment: ""))
            name.text = ""
            description.text = ""
            name.delegate = self
            description.delegate = self
            self.txtInputs.append((name, description))
            
            let swipeCell = newRow as! MGSwipeTableCell
            let deleteBtn = MGSwipeButton(title: NSLocalizedString("Delete", comment: ""), backgroundColor: UIColor.redColor(), callback: { _ in
                let cellIndex = self.cells.indicesOf(swipeCell)!.1
                self.removeCellFromSection(1, index: cellIndex)
                self.txtInputs.removeAtIndex(cellIndex - 1)
                return true
            })
            swipeCell.rightButtons = [deleteBtn]
            
            
            addCellToSection(1, cell: newRow)
        case (2, 0):
            let newRow = tableView.dequeueReusableCellWithIdentifier("doubleText")!
            
            let name = newRow.viewWithTag(1) as! JVFloatLabeledTextField
            let formula = newRow.viewWithTag(2) as! JVFloatLabeledTextField
            name.setPlaceholder(NSLocalizedString("Name", comment: ""), floatingTitle: NSLocalizedString("Name", comment: ""))
            formula.setPlaceholder(NSLocalizedString("Formula", comment: ""), floatingTitle: NSLocalizedString("Formula", comment: ""))
            name.text = ""
            formula.text = ""
            name.delegate = self
            formula.delegate = self
            self.txtResults.append((name, formula))
            
            let swipeCell = newRow as! MGSwipeTableCell
            let deleteBtn = MGSwipeButton(title: NSLocalizedString("Delete", comment: ""), backgroundColor: UIColor.redColor(), callback: { _ in
                let cellIndex = self.cells.indicesOf(swipeCell)!.1
                self.removeCellFromSection(2, index: cellIndex)
                self.txtResults.removeAtIndex(cellIndex - 1)
                return true
            })
            swipeCell.rightButtons = [deleteBtn]
            
            addCellToSection(2, cell: newRow)
        default:
            break;
        }
    }
    
    /*override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return 55
        case (let x, let y) where y >= 1 && x > 0:
            return 55
        default:
            return 44
        }
    }*/
    
    func addCellToSection(section: Int, cell: UITableViewCell) {
        cells[section].append(cell)
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: cells[section].endIndex - 1, inSection: section)], withRowAnimation: .Top)
    }
    
    func removeCellFromSection(section: Int, index: Int) {
        cells[section].removeAtIndex(index)
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: section)], withRowAnimation: .Left)
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
            return
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
        objToSave.availableInputs = NSOrderedSet(array: inputArr)
        
        var resultArr = [OperationResult]()
        for (name, formula) in txtResults {
            let result = OperationResult(entity: entityResult!, insertIntoManagedObjectContext: dataContext, formula: formula.text!, name: name.text!, operation: objToSave)
            resultArr.append(result)
        }
        objToSave.results = NSOrderedSet(array: resultArr)
        
        dataContext.saveData()
        performSegueWithIdentifier("custOpSaved", sender: self)
    }
}

extension Array where Element : CollectionType,
Element.Generator.Element : Equatable, Element.Index == Int {
    func indicesOf(x: Element.Generator.Element) -> (Int, Int)? {
        for (i, row) in self.enumerate() {
            if let j = row.indexOf(x) {
                return (i, j)
            }
        }
        return nil
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