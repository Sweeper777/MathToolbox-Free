import UIKit
import GoogleMobileAds

class OperationListViewController: UITableViewController, GADInterstitialDelegate, SKStoreProductViewControllerDelegate {
    lazy var operationsList: [(category: String, operations: [Operation])] = [
        ("2D Figures", [Trapizium(), PolygonAngles()]),
        ("Circles", [Circle(), Arc(), Sector()]),
        ("Triangles", [Triangle(), TriangleInequality(), TrigAndPyth(), Trigonometry()]),
        ("Factors and Multiples", [Factors(), PrimeFactors(), FactorPairs(), LeastCommonMultiple()]),
        ("General Numbers", [PrimeNumber(), SciNotation(), RandomNumGen()]),
        ("Date and Time", [TimeInterval()]),
        ("Misc", [DegreesRadiansGradians(), HexDecBinOct()])
    ]
    var operationToPass: Operation?
    let storeViewController = SKStoreProductViewController()
    var storeViewLoaded = false

    @IBAction func infoClicked(sender: UIBarButtonItem) {
        func fullVerisonClick (sender: UIAlertAction) {
            openStoreProductWithiTunesItemIdentifier(identifier: "1080075778")
        }
        
        func aboutClick (sender: UIAlertAction) {
            performSegue(withIdentifier: "showAbout", sender: self)
        }
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Get the Full Version!", comment: ""), style: .default, handler: fullVerisonClick))
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("About", comment: ""), style: .default, handler: aboutClick))
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        actionSheet.popoverPresentationController?.barButtonItem = sender
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func openStoreProductWithiTunesItemIdentifier(identifier: String) {
        if storeViewLoaded {
            self.present(storeViewController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Loading", comment: ""), message: NSLocalizedString("Still Loading App Store... Please try again later. This may be caused by slow or no Internet connection.", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.section == operationsList.endIndex {
            cell.textLabel!.text = NSLocalizedString("Custom Operations", comment: "")
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        cell.textLabel?.text = NSLocalizedString(operationsList[indexPath.section].operations[indexPath.row].operationName, comment: "")
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == operationsList.endIndex {
            return 1
        }
        
        return operationsList[section].operations.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return operationsList.count + 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableView.tableHeaderView?.backgroundColor = UIColor(red: 0x5a / 0xff, green: 0xbb / 0xff, blue: 0x5a / 0xff, alpha: 1.0)
        
        if section == operationsList.endIndex {
            return NSLocalizedString("Custom", comment: "")
        }
        
        return NSLocalizedString(operationsList[section].category, comment: "")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == operationsList.endIndex {
            if !UserSettings.prefHideWarning {
                let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("This feature is for experienced users only", comment: ""), preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) {_ in self.performSegue(withIdentifier: "showCustomOperations", sender: self) })
                alert.addAction(UIAlertAction(title: NSLocalizedString("Do not show again", comment: ""), style: .default) {
                    (_) in UserSettings.prefHideWarning = true
                    self.performSegue(withIdentifier: "showCustomOperations", sender: self)
                })
                alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "showCustomOperations", sender: self)
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        operationToPass = operationsList[indexPath.section].operations[indexPath.row]
        performSegue(withIdentifier: "showOperation", sender: tableView)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOperation" {
            let vc = segue.destination as! OperationViewController
            vc.operation = operationToPass
        }
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor(red: 0xca / 0xff, green: 1, blue: 0xc7 / 0xff, alpha: 1.0)
        headerView.text = "  " + self.tableView(tableView, titleForHeaderInSection: section)!
        let fontD: UIFontDescriptor = headerView.font.fontDescriptor.withSymbolicTraits(.traitBold)!
        headerView.font = UIFont(descriptor: fontD, size: 0)
        return headerView
    }
    
    //==================AD STUFF=======================
    
    var ad = GADInterstitial(adUnitID: adId)
    var appearCallCount: Int!
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial!) {
        ad.present(fromRootViewController: self)
    }
    
    func interstitial(_ ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
        self.perform(#selector(OperationListViewController.loadNewAd), with: nil, afterDelay: 60.0)
    }
    
    func loadNewAd() {
        if let parentVC = self.parent {
            if (parentVC as! UINavigationController).topViewController !== self {
                return
            }
        } else {
            return
        }
        
        ad = GADInterstitial(adUnitID: adId)
        ad.delegate = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        ad.load(request)
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial!) {
        self.perform(#selector(OperationListViewController.loadNewAd), with: nil, afterDelay: 120.0)
    }
    
    override func viewDidLoad() {
        ad.delegate = self
        appearCallCount = 0
        
        if arc4random_uniform(100) < 30 {
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            ad.load(request)
        } else {
            self.perform(#selector(OperationListViewController.loadNewAd), with: nil, afterDelay: 120.0)
        }
        
        UINavigationBar.appearance().barStyle = .black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        storeViewController.delegate = self
        
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : "1080075778"]
        storeViewController.loadProduct(withParameters: parameters) { (loaded, error) in
            self.storeViewLoaded = loaded
        }
    }
    
    func showRateMsg() {
        let alert = UIAlertController(title: NSLocalizedString("Enjoying Math Toolbox?", comment: ""), message: NSLocalizedString("You can rate this app, or send me feedback!", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Rate!", comment: ""), style: .default) { _ in
                UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/us/app/math-toolbox-free/id1080062807?ls=1&mt=8")!)
            })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Send Feedback", comment: ""), style: .default) { _ in
            UIApplication.shared.openURL(URL(string: "mailto://sumulang@gmail.com")!)
            })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Maybe Later", comment: ""), style: .default, handler: nil))
        self.presentVC(alert)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if appearCallCount == nil {
            appearCallCount = 0
        }
        
        if appearCallCount == 0 && arc4random_uniform(100) < 10 {
            loadNewAd()
        } else {
            if arc4random_uniform(100) < 20 {
                showRateMsg()
            }
            
            self.perform(#selector(OperationListViewController.loadNewAd), with: nil, afterDelay: 120.0)
        }
        
        appearCallCount! += 1
    }
}
