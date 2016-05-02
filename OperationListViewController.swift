import UIKit
import GoogleMobileAds

class OperationListViewController: UITableViewController, GADInterstitialDelegate, SKStoreProductViewControllerDelegate {
    let operationsList: [(category: String, operations: [Operation])] = [
        ("2D Figures", [Trapizium(), Triangle(), PolygonAngles()]),
        ("Circles", [Circle(), Arc(), Sector()]),
        ("Triangles", [TriangleInequality(), TrigAndPyth()]),
        ("Factors and Multiples", [Factors(), PrimeFactors(), FactorPairs(), LeastCommonMultiple()]),
        ("General Numbers", [PrimeNumber(), SciNotation()]),
        ("Misc", [DegreesRadiansGradians(), HexDecBinOct()])
    ]
    var operationToPass: Operation?
    
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
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : identifier]
        storeViewController.loadProductWithParameters(parameters) { [weak self] (loaded, error) -> Void in
            if loaded {
                // Parent class of self is UIViewContorller
                self?.presentViewController(storeViewController, animated: true, completion: nil)
            }
        }
    }
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = NSLocalizedString(operationsList[indexPath.section].operations[indexPath.row].operationName, comment: "")
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operationsList[section].operations.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return operationsList.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString(operationsList[section].category, comment: "")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
        self.performSelector(#selector(OperationListViewController.loadNewAd), withObject: nil, afterDelay: 60.0)
    }
    
    override func viewDidLoad() {
        ad.delegate = self
        appearCallCount = 0
        
        if arc4random_uniform(100) < 30 {
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            ad.loadRequest(request)
        } else {
            self.performSelector(#selector(OperationListViewController.loadNewAd), withObject: nil, afterDelay: 60.0)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if appearCallCount == nil {
            appearCallCount = 0
        }
        
        if appearCallCount == 0 && arc4random_uniform(100) < 10 {
            loadNewAd()
        } else {
            self.performSelector(#selector(OperationListViewController.loadNewAd), withObject: nil, afterDelay: 60.0)
        }
        
        appearCallCount! += 1
    }
}
