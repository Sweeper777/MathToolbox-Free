import UIKit

class AboutController: UITableViewController {
    @IBOutlet var versionLabel: UILabel!
    
    override func viewDidLoad() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        versionLabel.text = NSLocalizedString("Version:", comment: "") + " \(version)"
    }
}
