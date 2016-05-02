import UIKit
import GoogleMobileAds
import MathParser

class OperationViewController: UITableViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, GADInterstitialDelegate {
    var operation: Operation!
    var hasImage = false
    var views: [(label: UILabel, textField: UITextField)] = []
    var sectionIndexForInputs = 0
    
    override func viewDidLoad() {
        title = NSLocalizedString(operation.operationName, comment: "")
        
        if operation.operationImage != nil {
            sectionIndexForInputs = 1
        }
        
        views = []
        addBlanks()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(OperationViewController.tapped(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(OperationViewController.swipedDown(_:)))
        swipe.direction = .Down
        swipe.delegate = self
        view.addGestureRecognizer(swipe)
        
        ad.delegate = self
        appearCallCount = 0
        
        if arc4random_uniform(100) < 15 {
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            ad.loadRequest(request)
        } else {
            self.performSelector(#selector(OperationViewController.loadNewAd), withObject: nil, afterDelay: 60.0)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == sectionIndexForInputs - 1 {
            let cell = UITableViewCell()
            let imageView = UIImageView.init(frame: CGRectMake(100, 0, 140, 140))
            imageView.image = operation.operationImage
            cell.contentView.addSubview(imageView)
            return cell
        }
        
        let cell = UITableViewCell()
        
        cell.contentView.addSubview(views[indexPath.row].label)
        cell.contentView.addSubview(views[indexPath.row].textField)
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == sectionIndexForInputs {
            return operation.operationAvailableInputs.count
        }
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if operation.operationImage != nil {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == sectionIndexForInputs {
            return NSLocalizedString("inputs", comment: "")
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == sectionIndexForInputs - 1 {
            return 140
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    @IBAction func swipedDown(sender: UISwipeGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func tapped(sender: AnyObject) {
        view.endEditing(true)
    }
    
    private func getResults () -> [(name: String, from: String, result: String)]? {
        var input: [String: Double] = [:]
        for i in 0  ..< views.count  {
            var candidate = 0.0
            var evaluator = Evaluator()
            evaluator.angleMeasurementMode = .Degrees
            let evaluatedResult = try? evaluator.evaluate(Expression(string: views[i].textField.text!))
            
            if evaluatedResult == nil {
                continue
            }
            
            if operation.operationRejectFloatingPoint {
                if evaluatedResult! != rint(evaluatedResult!) {
                    continue
                } else {
                    candidate = evaluatedResult!
                }
            } else {
                candidate = evaluatedResult!
            }
            input[operation.operationAvailableInputs[i].name] = candidate
        }
        
        if input.count == 0 {
            return nil
        } else {
            return operation.calculate(input)
        }
    }
    
    private func addBlanks () {
        for (name, _) in operation.operationAvailableInputs {
            let label = UILabel(frame: CGRect(x: CGFloat(15), y: CGFloat(10), width: CGFloat(0), height: CGFloat(0)))
            label.text = name + " = "
            label.font = UIFont(name: "Times New Roman", size: CGFloat(20))
            label.sizeToFit()
            let textBox = UITextField(frame: CGRect(x: 80, y: 5, width: tableView.frame.width - label.frame.width - 10, height: label.frame.height + 10))
            textBox.placeholder = "\(NSLocalizedString("Enter", comment: "")) \(name)"
            textBox.borderStyle = .None
            textBox.delegate = self
            textBox.keyboardType = .NumbersAndPunctuation
            views.append((label, textBox))
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showOperationHelp" {
            let vc = segue.destinationViewController as! HelpViewController
            var helpString = "<h1>\(NSLocalizedString(operation.operationName, comment: ""))</h1><ul>"
            for (name, desc) in operation.operationAvailableInputs {
                helpString += "<li>\(NSLocalizedString(name, comment: "")): \(NSLocalizedString(desc, comment: "").stringByReplacingOccurrencesOfString("ANGLE_MEASURE", withString: NSLocalizedString(UserSettings.angleMeasure.rawValue, comment: "")))</li>"
            }
            helpString += "</ul>"
            helpString += operation.operationRejectFloatingPoint ? NSLocalizedString("This operation accepts integers ONLY. Other forms of input will be ignored", comment: "") : ""
            vc.helpString = helpString
        } else if segue.identifier == "showResults" {
            let vc = segue.destinationViewController as! ResultsViewController
            vc.results = getResults()
        }
        view.endEditing(true)
    }
    
    //==================AD STUFF=======================
    
    var ad = GADInterstitial(adUnitID: adId)
    var appearCallCount: Int!
    
    func interstitialDidReceiveAd(ad: GADInterstitial!) {
        ad.presentFromRootViewController(self)
    }
    
    func interstitial(ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
        self.performSelector(#selector(OperationViewController.loadNewAd), withObject: nil, afterDelay: 60.0)
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
        self.performSelector(#selector(OperationViewController.loadNewAd), withObject: nil, afterDelay: 60.0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if appearCallCount == nil {
            appearCallCount = 0
        }
        
        if appearCallCount == 0 && arc4random_uniform(100) < 5 {
            loadNewAd()
        } else {
            self.performSelector(#selector(OperationViewController.loadNewAd), withObject: nil, afterDelay: 60.0)
        }
        
        appearCallCount! += 1
    }
}
