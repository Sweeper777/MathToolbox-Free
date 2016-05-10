import UIKit
import CoreData
import MGSwipeTableCell

class CustOpListController: UITableViewController {
    var operations = [OperationEntity]()
    let dataContext: NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
        if dataContext != nil {
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
            // TODO: edit button
            return true
        }
        
        cell.rightButtons = [deleteBtn, editBtn]
        cell.rightSwipeSettings.transition = .Drag
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // TODO: prepareForSegue
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