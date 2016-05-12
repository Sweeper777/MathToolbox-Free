import UIKit
import CoreData
import MGSwipeTableCell

class CustOpListController: UITableViewController {
    var operations = [OperationEntity]()
    let dataContext: NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    var operationToPass: OperationEntity!
    
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
        let deleteBtn = MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor()) {
            _ in
            self.dataContext.deleteObject(self.operations[indexPath.row])
            self.dataContext.saveData()
            self.operations.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            return true
        }
        
        let editBtn = MGSwipeButton(title: "Edit", backgroundColor: UIColor.lightGrayColor()) {
            _ in
            self.operationToPass = self.operations[indexPath.row]
            self.performSegueWithIdentifier("showEditor", sender: self)
            return true
        }
        
        cell.rightButtons = [deleteBtn, editBtn]
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
        }
    }
    
    @IBAction func addNew(sender: UIBarButtonItem) {
        operationToPass = nil
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