import UIKit

class AboutController: UITableViewController {
    @IBOutlet var versionLabel: UILabel!
    
    override func viewDidLoad() {
        let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as! String
        versionLabel.text = NSLocalizedString("Version:", comment: "") + " \(version)"
    }
}
