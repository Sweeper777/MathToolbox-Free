import UIKit

class ExportController: UITableViewController {
    @IBOutlet var exportedTextView: UITextView!
    var exportedText: String!
    
    override func viewDidLoad() {
        exportedTextView.text = exportedText
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        dismissVC(completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            UIPasteboard.generalPasteboard().string = exportedText
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
