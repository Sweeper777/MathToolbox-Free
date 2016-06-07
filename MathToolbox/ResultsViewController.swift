import UIKit
import GoogleMobileAds

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GADInterstitialDelegate {
    var results: [(name: String, from: String, result: String)]?
    var mappedResults: [(category: String, items: [(String, String)])] = []
    var noResult = false
    
    override func viewDidLoad() {
        automaticallyAdjustsScrollViewInsets = false
        if results == nil {
            noResult = true
            return
        }
        
        var mappedResultCategories: [String] = []
        var mappedResultValues: [[(String, String)]] = []
        
        for result in results! {
            if !mappedResultCategories.contains(result.name) {
                mappedResultCategories.append(result.name)
                mappedResultValues.append([(result.result, "\(String(format: NSLocalizedString("From", comment: ""), result.from))")])
            } else {
                let index: Int = mappedResultCategories.indexOf(result.name)!
                mappedResultValues[index].append((result.result, "\(String(format: NSLocalizedString("From", comment: ""), result.from))"))
            }
        }
        
        assert(mappedResultCategories.count == mappedResultValues.count)
        
        for i in 0  ..< mappedResultValues.count  {
            mappedResults.append((mappedResultCategories[i], mappedResultValues[i]))
        }
        
        ad.delegate = self
        appearCallCount = 0
        
        if arc4random_uniform(100) < 20 {
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            ad.loadRequest(request)
        } else {
            self.performSelector(#selector(ResultsViewController.loadNewAd), withObject: nil, afterDelay: 60.0)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: nil)
        if results == nil {
            cell.textLabel!.text = NSLocalizedString("No Results", comment: "")
        } else {
            cell.textLabel?.text = mappedResults[indexPath.section].items[indexPath.row].0
            cell.detailTextLabel?.text = mappedResults[indexPath.section].items[indexPath.row].1
            cell.textLabel?.numberOfLines = 0
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if results == nil {
            return 1
        }
        return mappedResults[section].items.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if results == nil {
            return 1
        }
        return mappedResults.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if results == nil {
            return nil
        }
        return NSLocalizedString(mappedResults[section].category, comment: "")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if mappedResults.count == 0 {
            return
        }
        
        UIPasteboard.generalPasteboard().string = mappedResults[indexPath.section].items[indexPath.row].0
        let alert = UIAlertController(title: NSLocalizedString("Success!", comment: ""), message: "\(NSLocalizedString("The result", comment: "")) \"\(mappedResults[indexPath.section].items[indexPath.row].0)\" \(NSLocalizedString("has been copied to the clipboard.", comment: ""))", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        cell.sizeToFit()
        return cell.bounds.height
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, 30))
        headerView.backgroundColor = UIColor(red: 0xca / 0xff, green: 1, blue: 0xc7 / 0xff, alpha: 1.0)
        headerView.text = "  " + (self.tableView(tableView, titleForHeaderInSection: section) ?? "")
        let fontD: UIFontDescriptor = headerView.font.fontDescriptor().fontDescriptorWithSymbolicTraits(.TraitBold)
        headerView.font = UIFont(descriptor: fontD, size: 0)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if noResult {
            return 0
        }
        
        return UITableViewAutomaticDimension
    }
    
    //==================AD STUFF=======================
    
    var ad = GADInterstitial(adUnitID: adId)
    var appearCallCount: Int!
    
    func interstitialDidReceiveAd(ad: GADInterstitial!) {
        ad.presentFromRootViewController(self)
    }
    
    func interstitial(ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
        self.performSelector(#selector(ResultsViewController.loadNewAd), withObject: nil, afterDelay: 60.0)
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
        self.performSelector(#selector(ResultsViewController.loadNewAd), withObject: nil, afterDelay: 60.0)
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
            if arc4random_uniform(100) < 30 {
                showRateMsg()
            }
            
            self.performSelector(#selector(ResultsViewController.loadNewAd), withObject: nil, afterDelay: 60.0)
        }
        
        appearCallCount! += 1
    }
}
