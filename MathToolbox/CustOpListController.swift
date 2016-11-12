import UIKit
import CoreData
import MGSwipeTableCell
import StoreKit

class CustOpListController: UITableViewController, FullVersionAlertShowable {
    var operations = [OperationEntity]()
    let dataContext: NSManagedObjectContext! = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
    var operationToPass: OperationEntity!
    var jsonStringToPass: String!
    
    var vc: UIViewController { return self }
    let storeViewController = SKStoreProductViewController()
    var storeViewLoaded = false
    
    func reloadData() {
        if dataContext != nil {
            self.operations.removeAll()
            let entity = NSEntityDescription.entity(forEntityName: "OperationEntity", in: dataContext)
            let request = NSFetchRequest<NSFetchRequestResult>()
            request.entity = entity
            let operations = try? dataContext.fetch(request)
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MGSwipeTableCell()
        cell.textLabel?.text = operations[indexPath.row].name
        let deleteBtn = MGSwipeButton(title: NSLocalizedString("Delete", comment: ""), backgroundColor: UIColor.red) {
            _ in
            self.dataContext.delete(self.operations[indexPath.row])
            self.dataContext.saveData()
            self.operations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
            return true
        }
        
        let editBtn = MGSwipeButton(title: NSLocalizedString("Edit", comment: ""), backgroundColor: UIColor.lightGray) {
            _ in
            self.operationToPass = self.operations[indexPath.row]
            self.performSegue(withIdentifier: "showEditor", sender: self)
            return true
        }
        
//        let exportBtn = MGSwipeButton(title: "", icon: UIImage(named: "export"), backgroundColor: UIColor(hexString: "5abb5a")) {
//            _ in
//            let op = self.operations[indexPath.row]
//            self.jsonStringToPass = op.toJSON().rawString()!
//            self.performSegueWithIdentifier("showExport", sender: self)
//            return true
//        }
        
        cell.rightButtons = [deleteBtn, editBtn]
        cell.rightSwipeSettings.transition = .drag
        
//        cell.leftButtons = [exportBtn]
//        cell.rightSwipeSettings.transition = .Drag
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        operationToPass = operations[indexPath.row]
        performSegue(withIdentifier: "enterCustOp", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DataPasserController {
            vc.operationEntity = operationToPass
            vc.jsonString = jsonStringToPass
        } else if let vc = segue.destination as? OperationViewController {
            vc.operation = CustomOperation(entity: operationToPass)
        } else if let vc = segue.destination as? HelpViewController {
            vc.helpString = NSLocalizedString("custOpHelp", comment: "")
        }
    }
    
    @IBAction func addNew(sender: UIBarButtonItem) {
        operationToPass = nil
        if operations.count >= 5 {
            self.showFullVersionAlert(msg: "You cannot have more than 5 custom operations in the free version. Get the full version to create unlimited custom operations!")
            return
        }
        
        performSegue(withIdentifier: "showEditor", sender: self)
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
