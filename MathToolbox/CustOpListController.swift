import UIKit
import CoreData
import MGSwipeTableCell
import StoreKit

class CustOpListController: UITableViewController, FullVersionAlertShowable {
    var operations = [OperationEntity]()
    let dataContext: NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    var operationToPass: OperationEntity!
    
    var vc: UIViewController { return self }
    let storeViewController = SKStoreProductViewController()
    var storeViewLoaded = false
    
    func reloadData() {
        if dataContext != nil {
            self.operations.removeAll()
            let entity = NSEntityDescription.entityForName("OperationEntity", inManagedObjectContext: dataContext)
            let request = NSFetchRequest()
            request.entity = entity
            let operations = try? dataContext.executeFetchRequest(request)
            if operations != nil {
                for item in operations! {
                    self.operations.append(item as! OperationEntity)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initStoreView()
        self.clearsSelectionOnViewWillAppear = false
        reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = MGSwipeTableCell()
        cell.textLabel?.text = operations[indexPath.row].name
        let deleteBtn = MGSwipeButton(title: NSLocalizedString("Delete", comment: ""), backgroundColor: UIColor.redColor()) {
            _ in
            self.dataContext.deleteObject(self.operations[indexPath.row])
            self.dataContext.saveData()
            self.operations.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            return true
        }
        
        let editBtn = MGSwipeButton(title: NSLocalizedString("Edit", comment: ""), backgroundColor: UIColor.lightGrayColor()) {
            _ in
            self.operationToPass = self.operations[indexPath.row]
            self.performSegueWithIdentifier("showEditor", sender: self)
            return true
        }
        
        let exportBtn = MGSwipeButton(title: "hello", icon: UIImage(named: "export"), backgroundColor: UIColor(hexString: "5abb5a")) {
            _ in
            let op = self.operations[indexPath.row]
            
            self.performSegueWithIdentifier("showExport", sender: self)
            return true
        }
        
        cell.rightButtons = [deleteBtn, editBtn]
        cell.rightSwipeSettings.transition = .Drag
        
        cell.leftButtons = [exportBtn]
        cell.rightSwipeSettings.transition = .Drag
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        operationToPass = operations[indexPath.row]
        performSegueWithIdentifier("enterCustOp", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? DataPasserController {
            vc.operationEntity = operationToPass
        } else if let vc = segue.destinationViewController as? OperationViewController {
            vc.operation = CustomOperation(entity: operationToPass)
        } else if let vc = segue.destinationViewController as? HelpViewController {
            vc.helpString = NSLocalizedString("custOpHelp", comment: "")
        }
    }
    
    @IBAction func addNew(sender: UIBarButtonItem) {
        operationToPass = nil
        if operations.count >= 5 {
            self.showFullVersionAlert("You cannot have more than 5 custom operations in the free version. Get the full version to create unlimited custom operations!")
            return
        }
        
        performSegueWithIdentifier("showEditor", sender: self)
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        reloadData()
        tableView.reloadData()
    }
}

extension NSManagedObjectContext {
    func saveData() -> Bool {
        do {
            try self.save()
            return true
        } catch let error as NSError {
            print(error)
            return false;
        }
    }
}