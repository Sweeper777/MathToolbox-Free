import UIKit
import MGSwipeTableCell
import CoreData
import JVFloatLabeledTextField
import StoreKit

// (╯°□°）╯︵ ┻━┻ Oh... sad memories...
class CustOpEditorController: UITableViewController, UITextFieldDelegate, FullVersionAlertShowable {
    var cells: [[UITableViewCell]] = [[], [], []]
    
    var operationEntity: OperationEntity?
    
    var txtInputs = [(JVFloatLabeledTextField, JVFloatLabeledTextField)]()
    var txtResults = [(JVFloatLabeledTextField, JVFloatLabeledTextField)]()
    var txtName: JVFloatLabeledTextField!
    var switchRejectFloatingPoint: UISwitch!
    
    var editingInput = false
    var editingResult = false
    
    var vc: UIViewController { return self }
    let storeViewController = SKStoreProductViewController()
    var storeViewLoaded = false
    
    override func viewDidLoad() {
        initStoreView()
        if operationEntity == nil {
            navigationItem.title = NSLocalizedString("New Custom Operation", comment: "")
        } else {
            navigationItem.title = operationEntity!.name!
        }
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "normalText")!
        
        self.txtName = cell1.viewWithTag(1) as! JVFloatLabeledTextField
        self.txtName.setPlaceholder(NSLocalizedString("Name", comment: ""), floatingTitle: NSLocalizedString("Name", comment: ""))
        self.txtName.text = self.operationEntity?.name ?? ""
        self.txtName.delegate = self
        changeFontOfTextField(txtField: txtName)
        
        addCellToSection(section: 0, cell: cell1)
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "switch")!
        
        self.switchRejectFloatingPoint = cell2.viewWithTag(2) as! UISwitch
        self.switchRejectFloatingPoint.isOn = self.operationEntity?.rejectFloatingPoint?.boolValue ?? false
        
        addCellToSection(section: 0, cell: cell2)
        
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "button")!
        cell3.textLabel!.text = NSLocalizedString("Add New Input", comment: "")
        
        addCellToSection(section: 1, cell: cell3)
        
        if let inputs = operationEntity?.availableInputs {
            for input in inputs {
                let realInput = input as! OperationInput
                let cell4 = tableView.dequeueReusableCell(withIdentifier: "doubleText")!
                
                let name = cell4.viewWithTag(1) as! JVFloatLabeledTextField
                let description = cell4.viewWithTag(2) as! JVFloatLabeledTextField
                name.setPlaceholder(NSLocalizedString("Name", comment: ""), floatingTitle: NSLocalizedString("Name", comment: ""))
                description.setPlaceholder(NSLocalizedString("Description", comment: ""), floatingTitle: NSLocalizedString("Description", comment: ""))
                name.text = realInput.name!
                description.text = realInput.desc!
                name.delegate = self
                description.delegate = self
                changeFontOfTextField(txtField: name)
                changeFontOfTextField(txtField: description)
                self.txtInputs.append((name, description))
                
                let swipeCell = cell4 as! MGSwipeTableCell
                let deleteBtn = MGSwipeButton(title: NSLocalizedString("Delete", comment: ""), backgroundColor: UIColor.red, callback: { _ in
                    let cellIndex = self.cells.indicesOf(x: swipeCell)!.1
                    self.removeCellFromSection(section: 1, index: cellIndex)
                    self.txtInputs.remove(at: cellIndex - 1)
                    return true
                })
                swipeCell.rightButtons = [deleteBtn!]
                
                addCellToSection(section: 1, cell: cell4)
            }
        }
        
        let cell5 = tableView.dequeueReusableCell(withIdentifier: "button")!
        
        cell5.textLabel!.text = NSLocalizedString("Add New Result", comment: "")
        
        addCellToSection(section: 2, cell: cell5)
        
        if let results = operationEntity?.results {
            for result in results {
                let realResult = result as! OperationResult
                let cell6 = tableView.dequeueReusableCell(withIdentifier: "doubleText")!
                
                let name = cell6.viewWithTag(1) as! JVFloatLabeledTextField
                let formula = cell6.viewWithTag(2) as! JVFloatLabeledTextField
                name.setPlaceholder(NSLocalizedString("Name", comment: ""), floatingTitle: NSLocalizedString("Name", comment: ""))
                formula.setPlaceholder(NSLocalizedString("Formula", comment: ""), floatingTitle: NSLocalizedString("Formula", comment: ""))
                name.text = realResult.name!
                formula.text = realResult.formula!
                name.delegate = self
                formula.delegate = self
                changeFontOfTextField(txtField: name)
                changeFontOfTextField(txtField: formula)
                
                self.txtResults.append((name, formula))
                
                let swipeCell = cell6 as! MGSwipeTableCell
                let deleteBtn = MGSwipeButton(title: NSLocalizedString("Delete", comment: ""), backgroundColor: UIColor.red, callback: { _ in
                    let cellIndex = self.cells.indicesOf(x: swipeCell)!.1
                    self.removeCellFromSection(section: 2, index: cellIndex)
                    self.txtResults.remove(at: cellIndex)
                    return true
                })
                swipeCell.rightButtons = [deleteBtn!]
                
                addCellToSection(section: 2, cell: cell6)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.section][indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            let newRow = tableView.dequeueReusableCell(withIdentifier: "doubleText")!
            
            let name = newRow.viewWithTag(1) as! JVFloatLabeledTextField
            let description = newRow.viewWithTag(2) as! JVFloatLabeledTextField
            name.setPlaceholder(NSLocalizedString("Name", comment: ""), floatingTitle: NSLocalizedString("Name", comment: ""))
            description.setPlaceholder(NSLocalizedString("Description", comment: ""), floatingTitle: NSLocalizedString("Description", comment: ""))
            name.text = ""
            description.text = ""
            name.delegate = self
            description.delegate = self
            changeFontOfTextField(txtField: name)
            changeFontOfTextField(txtField: description)
            self.txtInputs.append((name, description))
            
            let swipeCell = newRow as! MGSwipeTableCell
            let deleteBtn = MGSwipeButton(title: NSLocalizedString("Delete", comment: ""), backgroundColor: UIColor.red, callback: { _ in
                let cellIndex = self.cells.indicesOf(x: swipeCell)!.1
                self.removeCellFromSection(section: 1, index: cellIndex)
                self.txtInputs.remove(at: cellIndex - 1)
                return true
            })
            swipeCell.rightButtons = [deleteBtn!]
            
            
            addCellToSection(section: 1, cell: newRow)
        case (2, 0):
            let newRow = tableView.dequeueReusableCell(withIdentifier: "doubleText")!
            
            let name = newRow.viewWithTag(1) as! JVFloatLabeledTextField
            let formula = newRow.viewWithTag(2) as! JVFloatLabeledTextField
            name.setPlaceholder(NSLocalizedString("Name", comment: ""), floatingTitle: NSLocalizedString("Name", comment: ""))
            formula.setPlaceholder(NSLocalizedString("Formula", comment: ""), floatingTitle: NSLocalizedString("Formula", comment: ""))
            name.text = ""
            formula.text = ""
            name.delegate = self
            formula.delegate = self
            changeFontOfTextField(txtField: name)
            changeFontOfTextField(txtField: formula)
            
            self.txtResults.append((name, formula))
            
            let swipeCell = newRow as! MGSwipeTableCell
            let deleteBtn = MGSwipeButton(title: NSLocalizedString("Delete", comment: ""), backgroundColor: UIColor.red, callback: { _ in
                let cellIndex = self.cells.indicesOf(x: swipeCell)!.1
                self.removeCellFromSection(section: 2, index: cellIndex)
                self.txtResults.remove(at: cellIndex - 1)
                return true
            })
            swipeCell.rightButtons = [deleteBtn!]
            
            addCellToSection(section: 2, cell: newRow)
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
        tableView.insertRows(at: [IndexPath(row: cells[section].endIndex - 1, section: section)], with: .top)
    }
    
    func removeCellFromSection(section: Int, index: Int) {
        cells[section].remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: section)], with: .left)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var listOfInputNames = [UITextField]()
        txtInputs.forEach { listOfInputNames.append($0.0) }
        if listOfInputNames.contains(textField) {
            if let symbol = CustOpEditorUtils.symbolsDict[textField.text!] {
                textField.text = symbol
            }
        }
    }
    
    func showError(_ errStr: String) {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString(errStr, comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        var shouldReturn = false
        txtInputs.forEach {
            tuple in
            if tuple.1.0.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == "" || tuple.1.1.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == "" {
                shouldReturn = true
            }
        }
        
        if shouldReturn {
            self.showError("Please fill in all the blanks")
            return
        }
        
        txtResults.forEach {
            tuple in
            if tuple.1.0.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == "" || tuple.1.1.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == "" {
                shouldReturn = true
            }
            
        }
        
        if shouldReturn {
            self.showError("Please fill in all the blanks")
            return
        }
        
        if txtName.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == "" {
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
        
        if txtInputs.count > 7 {
            showFullVersionAlert("You cannot add more than 7 inputs in the free version. Get the full version for unlimited inputs!")
            return
        }
        
        if txtResults.count > 5 {
            showFullVersionAlert("You cannot add more than 5 results in the free version. Get the full version for unlimited results!")
            return
        }
        
        txtInputs.forEach {
            tuple in
            if (tuple.1.0.text?.characters.count)! > 2 {
                shouldReturn = true
            }
        }
        
        if shouldReturn {
            self.showError("Input names cannot be longer than 2 characters")
            return
        }
        
        txtInputs.forEach {
            tuple in
            let txt = tuple.1.0.text!
            if txt.contains(" ") || txt.contains("'") || txt.contains("$") {
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
            } else if formula.text!.contains("$") {
                self.showError("Formulas cannot contain dollar signs")
                return
            }
        }
        
        let mappedInputNames = txtInputs.map { $0.0.text! }
        
        if Set<String>(mappedInputNames).count != mappedInputNames.count {
            self.showError("Input names must not contain duplicates")
            return
        }
        
        let dataContext: NSManagedObjectContext! = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
        let entityOp = NSEntityDescription.entity(forEntityName: "OperationEntity", in: dataContext)!
        let entityInput = NSEntityDescription.entity(forEntityName: "OperationInput", in: dataContext)
        let entityResult = NSEntityDescription.entity(forEntityName: "OperationResult", in: dataContext)
        
        var objToSave: OperationEntity!
        if operationEntity != nil {
            for input in operationEntity!.availableInputs! {
                dataContext.delete(input as! NSManagedObject)
            }
            
            for result in operationEntity!.results! {
                dataContext.delete(result as! NSManagedObject)
            }
            objToSave = operationEntity
            objToSave.name = txtName.text!
            objToSave.rejectFloatingPoint = switchRejectFloatingPoint.isOn as NSNumber?
        } else {
            objToSave = OperationEntity(entity: entityOp, insertIntoManagedObjectContext: dataContext, name: txtName.text!, rejectFloatingPoint: switchRejectFloatingPoint.isOn)
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
        performSegue(withIdentifier: "custOpSaved", sender: self)
    }
    
    private func changeFontOfTextField(txtField: JVFloatLabeledTextField) {
        let font = txtField.floatingLabelFont
        txtField.floatingLabelFont = UIFont.boldSystemFont(ofSize: (font?.pointSize)!)
    }
}

extension Array where Element : Collection,
Element.Iterator.Element : Equatable, Element.Index == Int {
    func indicesOf(x: Element.Iterator.Element) -> (Int, Int)? {
        for (i, row) in self.enumerated() {
            if let j = row.index(of: x) {
                return (i, j)
            }
        }
        return nil
    }
}

func countCharatcersInString(_ str: String, c: Character) -> Int {
    var counter = 0
    for char in str.characters {
        if char == c {
            counter += 1
        }
    }
    return counter
}
