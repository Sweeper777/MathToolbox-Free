import UIKit
import GoogleMobileAds

class OperationListViewController: UITableViewController, GADInterstitialDelegate, SKStoreProductViewControllerDelegate {
    lazy var operationsList: [(category: String, operations: [Operation])] = [
        ("2D Figures", [Trapizium(), PolygonAngles()]),
        ("Circles", [Circle(), Arc(), Sector()]),
        ("Triangles", [Triangle(), TriangleInequality(), TrigAndPyth(), Trigonometry()]),
        ("Factors and Multiples", [Factors(), PrimeFactors(), FactorPairs(), LeastCommonMultiple()]),
        ("General Numbers", [PrimeNumber(), SciNotation(), RandomNumGen()]),
        ("Misc", [DegreesRadiansGradians(), HexDecBinOct()])
    ]
    var operationToPass: Operation?
    let storeViewController = SKStoreProductViewController()
    var storeViewLoaded = false
    
    @IBAction func infoClicked(sender: UIBarButtonItem) {
        func fullVerisonClick (sender: UIAlertAction) {
            openStoreProductWithiTunesItemIdentifier("1080075778")
        }
        
        func aboutClick (sender: UIAlertAction) {
            performSegueWithIdentifier("showAbout", sender: self)
        }
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Get the Full Version!", comment: ""), style: .Default, handler: fullVerisonClick))
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("About", comment: ""), style: .Default, handler: aboutClick))
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil))
        actionSheet.popoverPresentationController?.barButtonItem = sender
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func openStoreProductWithiTunesItemIdentifier(identifier: String) {
        if storeViewLoaded {
            self.presentViewController(storeViewController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Loading", comment: ""), message: NSLocalizedString("Still Loading App Store... Please try again later. This may be caused by slow or no Internet connection.", comment: ""), preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title:NSLocalizedString("OK", comment: ""), style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.section == operationsList.endIndex {
            cell.textLabel!.text = NSLocalizedString("Custom Operations", comment: "")
            cell.accessoryType = .DisclosureIndicator
            return cell
        }
        cell.textLabel?.text = NSLocalizedString(operationsList[indexPath.section].operations[indexPath.row].operationName, comment: "")
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == operationsList.endIndex {
            return 1
        }
        
        return operationsList[section].operations.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return operationsList.count + 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableView.tableHeaderView?.backgroundColor = UIColor(red: 0x5a / 0xff, green: 0xbb / 0xff, blue: 0x5a / 0xff, alpha: 1.0)
        
        if section == operationsList.endIndex {
            return NSLocalizedString("Custom", comment: "")
        }
        
        return NSLocalizedString(operationsList[section].category, comment: "")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == operationsList.endIndex {
            if !UserSettings.prefHideWarning {
                let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("This feature is for experienced users only", comment: ""), preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default) {_ in self.performSegueWithIdentifier("showCustomOperations", sender: self) })
                alert.addAction(UIAlertAction(title: NSLocalizedString("Do not show again", comment: ""), style: .Default) {
                    (_) in UserSettings.prefHideWarning = true
                    self.performSegueWithIdentifier("showCustomOperations", sender: self)
                })
                alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                self.performSegueWithIdentifier("showCustomOperations", sender: self)
            }
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            return
        }
        
        operationToPass = operationsList[indexPath.section].operations[indexPath.row]
        performSegueWithIdentifier("showOperation", sender: tableView)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showOperation" {
            let vc = segue.destinationViewController as! OperationViewController
            vc.operation = operationToPass
        }
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, 30))
        headerView.backgroundColor = UIColor(red: 0xca / 0xff, green: 1, blue: 0xc7 / 0xff, alpha: 1.0)
        headerView.text = "  " + self.tableView(tableView, titleForHeaderInSection: section)!
        let fontD: UIFontDescriptor = headerView.font.fontDescriptor().fontDescriptorWithSymbolicTraits(.TraitBold)
        headerView.font = UIFont(descriptor: fontD, size: 0)
        return headerView
    }
    
    //==================AD STUFF=======================
    
    var ad = GADInterstitial(adUnitID: adId)
    var appearCallCount: Int!
    
    func interstitialDidReceiveAd(ad: GADInterstitial!) {
        ad.presentFromRootViewController(self)
    }
    
    func interstitial(ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
        self.performSelector(#selector(OperationListViewController.loadNewAd), withObject: nil, afterDelay: 60.0)
    }
    
    func loadNewAd() {
        if let parentVC = self.parentViewController {
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
        ad.loadRequest(request)
    }
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        self.performSelector(#selector(OperationListViewController.loadNewAd), withObject: nil, afterDelay: 120.0)
    }
    
    override func viewDidLoad() {
        ad.delegate = self
        appearCallCount = 0
        
        if arc4random_uniform(100) < 30 {
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            ad.loadRequest(request)
        } else {
            self.performSelector(#selector(OperationListViewController.loadNewAd), withObject: nil, afterDelay: 120.0)
        }
        
        UINavigationBar.appearance().barStyle = .Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        storeViewController.delegate = self
        
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : "1080075778"]
        storeViewController.loadProductWithParameters(parameters) { (loaded, error) in
            self.storeViewLoaded = loaded
        }
    }
    
    func showRateMsg() {
        let alert = UIAlertController(title: NSLocalizedString("Enjoying Math Toolbox?", comment: ""), message: NSLocalizedString("You can rate this app, or send me feedback!", comment: ""), preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Rate!", comment: ""), style: .Default) { _ in
                UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/us/app/math-toolbox-free/id1080062807?ls=1&mt=8")!)
            })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Send Feedback", comment: ""), style: .Default) { _ in
            UIApplication.sharedApplication().openURL(NSURL(string: "mailto://sumulang@gmail.com")!)
            })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Maybe Later", comment: ""), style: .Default, handler: nil))
        self.presentVC(alert)
    }
    
    override func viewDidAppear(animated: Bool) {
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
            
            self.performSelector(#selector(OperationListViewController.loadNewAd), withObject: nil, afterDelay: 120.0)
        }
        
        appearCallCount! += 1
    }
}
