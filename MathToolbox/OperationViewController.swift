import UIKit
import GoogleMobileAds
import MathParser
import EZSwiftExtensions
import EZLoadingActivity

class OperationViewController: UITableViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, GADInterstitialDelegate {
    var operation: Operation!
    var hasImage = false
    var views: [(label: UILabel, textField: UITextField)] = []
    var sectionIndexForInputs = 0
    var results: [(name: String, from: String, result: String)]?
    
    override func viewDidLoad() {
        title = NSLocalizedString(operation.operationName, comment: "")
        
        if operation.operationImage != nil {
            sectionIndexForInputs = 1
        }
        
        views = []
        addBlanks()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
        swipe.direction = .down
        swipe.delegate = self
        view.addGestureRecognizer(swipe)
        
        ad.delegate = self
        appearCallCount = 0
        
        if arc4random_uniform(100) < 15 {
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            ad.load(request)
        } else {
            self.perform(#selector(OperationViewController.loadNewAd), with: nil, afterDelay: 120)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == sectionIndexForInputs - 1 {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            let imageView = UIImageView.init(frame: CGRect(x: 100, y: 0, width: 140, height: 140))
            imageView.image = operation.operationImage
            cell.contentView.addSubview(imageView)
            return cell
        }
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "button")!
            cell.selectionStyle = .gray
            return cell
        }
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        
        cell.contentView.addSubview(views[indexPath.row - 1].label)
        cell.contentView.addSubview(views[indexPath.row - 1].textField)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == sectionIndexForInputs {
            return operation.operationAvailableInputs.count + 1
        }
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if operation.operationImage != nil {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == sectionIndexForInputs {
            return NSLocalizedString("inputs", comment: "")
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == sectionIndexForInputs - 1 {
            return 140
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    @IBAction func swipedDown(sender: UISwipeGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func tapped(sender: UITapGestureRecognizer) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: sectionIndexForInputs))
        let pos = sender.location(ofTouch: 0, in: cell)
        if cell!.bounds.contains(pos) {
            views.forEach {
                $0.textField.text = ""
            }
        }
        view.endEditing(true)
        
        tableView.selectRow(at: IndexPath(row: 0, section: sectionIndexForInputs), animated: false, scrollPosition: .none)
        Timer.runThisAfterDelay(seconds: 0.1) {
            self.tableView.deselectRow(at: IndexPath(row: 0, section: self.sectionIndexForInputs), animated: true)
        }
    }
    
    @IBAction func calculateClick(sender: UIBarButtonItem) {
        shouldShowAd = false
        
        let overlay = UIView(frame: ((UIApplication.shared.delegate as! AppDelegate).window?.frame)!)
        overlay.tag = 1
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.parent!.view.addSubview(overlay)
        overlay.animate(duration: 0.2, animations: {overlay.backgroundColor = overlay.backgroundColor?.withAlphaComponent(0.5)}, completion: nil)
        
        EZLoadingActivity.show(NSLocalizedString("Calculating...", comment: ""), disableUI: true);
        { self.getResults() } ~> {
            result in
            EZLoadingActivity.hide()
            self.shouldShowAd = true
            self.results = result
            let overlay = self.parent!.view.viewWithTag(1)!
            overlay.animate(duration: 0.2, animations: {overlay.backgroundColor = overlay.backgroundColor?.withAlphaComponent(0)}, completion: nil)
            overlay.removeFromSuperview()
            self.performSegue(withIdentifier: "showResults", sender: self)
        };
    }
    
    private func getResults () -> [(name: String, from: String, result: String)]? {
        var input: [String: Double] = [:]
        for i in 0  ..< views.count  {
            var candidate = 0.0
            var evaluator = Evaluator()
            evaluator.angleMeasurementMode = .degrees
            let variables: [String: Double] = ["A": UserSettings.aValue, "B": UserSettings.bValue, "C": UserSettings.cValue]
            let evaluatedResult: Double? = try? evaluator.evaluate(Expression(string: views[i].textField.text!), substitutions: variables)
            
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
        return operation.calculate(inputs: input)
    }
    
    private func addBlanks () {
        for (name, _) in operation.operationAvailableInputs {
            let label = UILabel(frame: CGRect(x: CGFloat(15), y: CGFloat(10), width: CGFloat(0), height: CGFloat(0)))
            label.text = name + " = "
            label.font = UIFont(name: "Times New Roman", size: CGFloat(20))
            label.sizeToFit()
            let textBox = UITextField(frame: CGRect(x: 80, y: 5, width: tableView.frame.width - label.frame.width - 10, height: label.frame.height + 10))
            textBox.placeholder = "\(NSLocalizedString("Enter", comment: "")) \(name)"
            textBox.borderStyle = .none
            textBox.delegate = self
            textBox.keyboardType = .numbersAndPunctuation
            textBox.clearButtonMode = .whileEditing
            views.append((label, textBox))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOperationHelp" {
            let vc = segue.destination as! HelpViewController
            var helpString = "<h1>\(NSLocalizedString(operation.operationName, comment: ""))</h1><ul>"
            for (name, desc) in operation.operationAvailableInputs {
                helpString += "<li>\(NSLocalizedString(name, comment: "")): \(NSLocalizedString(desc, comment: "").replacingOccurrences(of: "ANGLE_MEASURE", with: NSLocalizedString(UserSettings.angleMeasure.rawValue, comment: "")))</li>"
            }
            helpString += "</ul>"
            helpString += operation.operationRejectFloatingPoint ? NSLocalizedString("This operation accepts integers ONLY. Other forms of input will be ignored", comment: "") : ""
            vc.helpString = helpString
        } else if segue.identifier == "showResults" {
            let vc = segue.destination as! ResultsViewController;
            vc.results = self.results
        }
        view.endEditing(true)
    }
    
    //==================AD STUFF=======================
    
    var ad = GADInterstitial(adUnitID: adId)
    var appearCallCount: Int!
    var shouldShowAd = true
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial!) {
        ad.present(fromRootViewController: self)
    }
    
    func interstitial(_ ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
        self.perform(#selector(OperationViewController.loadNewAd), with: nil, afterDelay: 60.0)
    }
    
    func loadNewAd() {
        if let parentVC = self.parent {
            if (parentVC as! UINavigationController).topViewController !== self || !shouldShowAd {
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
        self.perform(#selector(OperationViewController.loadNewAd), with: nil, afterDelay: 120)
    }
    
    func showRateMsg() {
        let alert = UIAlertController(title: NSLocalizedString("Enjoying Math Toolbox?", comment: ""), message: NSLocalizedString("You can rate this app, or send me feedback!", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Rate!", comment: ""), style: .default) { _ in
            UIApplication.shared.openURL(NSURL(string: "https://itunes.apple.com/us/app/math-toolbox-free/id1080062807?ls=1&mt=8")! as URL)
            })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Send Feedback", comment: ""), style: .default) { _ in
            UIApplication.shared.openURL(NSURL(string: "mailto://sumulang.apps@gmail.com")! as URL)
            })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Maybe Later", comment: ""), style: .default, handler: nil))
        self.presentVC(alert)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if appearCallCount == nil {
            appearCallCount = 0
        }
        
        if appearCallCount == 0 && arc4random_uniform(100) < 5 {
            loadNewAd()
        } else {
            if arc4random_uniform(100) < 10 {
                showRateMsg()
            }
            
            self.perform(#selector(OperationViewController.loadNewAd), with: nil, afterDelay: 120)
        }
        
        appearCallCount! += 1
    }
}
