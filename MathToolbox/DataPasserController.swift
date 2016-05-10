import UIKit

class DataPasserController: UINavigationController {
    var operationEntity: OperationEntity?
    
    override func viewDidLoad() {
        if let vc = self.topViewController as? CustOpEditorController {
            vc.operationEntity = operationEntity
        }
    }
}
