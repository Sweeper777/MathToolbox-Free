import UIKit

class ExportController: UITableViewController {
    @IBOutlet var exportedTextView: UITextView!
    var exportedText: String!
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        dismissVC(completion: nil)
    }
}
