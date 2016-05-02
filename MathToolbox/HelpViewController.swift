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
        adBanner.loadRequest(request)
        automaticallyAdjustsScrollViewInsets = false
        if helpString == nil {
            helpHtml.loadHTMLString(
                NSLocalizedString("helpText", comment: ""), baseURL: nil)
        } else {
            helpHtml.loadHTMLString(helpString!, baseURL: nil)
        }
    }
    
}
