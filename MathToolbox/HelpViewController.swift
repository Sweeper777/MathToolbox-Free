import UIKit
import GoogleMobileAds

class HelpViewController: UIViewController, GADInterstitialDelegate {
    var helpString: String?
    @IBOutlet var helpHtml: UIWebView!
    @IBOutlet var adBanner: GADBannerView!
    
    override func viewDidLoad() {
        adBanner.adUnitID = bannerAdId
        adBanner.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        adBanner.load(request)
        automaticallyAdjustsScrollViewInsets = false
        
        let stylesheet = try! String(contentsOfFile: Bundle.main.path(forResource: "modest", ofType: "css")!)
        
        if helpString == nil {
            helpHtml.loadHTMLString("<style>\(stylesheet)</style> \(NSLocalizedString("helpText", comment: ""))", baseURL: nil)
        } else {
            helpHtml.loadHTMLString("<style>\(stylesheet)</style> \(helpString!)", baseURL: nil)
        }
    }
    
}
