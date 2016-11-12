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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            UIPasteboard.general.string = exportedText
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
