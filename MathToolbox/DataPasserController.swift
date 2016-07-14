import UIKit

class DataPasserController: UINavigationController {
    var operationEntity: OperationEntity?
    var jsonString: String?
    
    override func viewDidLoad() {
        if let vc = self.topViewController as? CustOpEditorController {
            vc.operationEntity = operationEntity
        } else if let vc = self.topViewController as? ExportController {
            vc.exportedText = jsonString
        }
    }
}
