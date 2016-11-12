import UIKit
import StoreKit

protocol FullVersionAlertShowable: SKStoreProductViewControllerDelegate {
    var vc: UIViewController { get }
    var storeViewController: SKStoreProductViewController { get }
    var storeViewLoaded: Bool { get set }
}

extension FullVersionAlertShowable {
    private func openStoreProductWithiTunesItemIdentifier(identifier: String) {
        if storeViewLoaded {
            vc.present(storeViewController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Loading", comment: ""), message: NSLocalizedString("Still Loading App Store... Please try again later. This may be caused by slow or no Internet connection.", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func showFullVersionAlert (msg: String) {
        let alert = UIAlertController(title: NSLocalizedString("Sorry!", comment: ""), message: NSLocalizedString(msg, comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Get the Full Version!", comment: ""), style: .default) { _ in self.openStoreProductWithiTunesItemIdentifier(identifier: "1080075778") })
        alert.addAction(UIAlertAction(title: NSLocalizedString("No Thanks!", comment: ""), style: .cancel, handler: nil))
        vc.presentVC(alert)
    }
    
    func initStoreView() {
        storeViewController.delegate = self
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : "1080075778"]
        storeViewController.loadProduct(withParameters: parameters) { (loaded, error) in
            self.storeViewLoaded = loaded
        }
    }
}
