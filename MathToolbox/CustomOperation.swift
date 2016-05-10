import UIKit

class CustomOperation : Operation {
    let operationEntity: OperationEntity
    
    var operationName: String { return operationEntity.name! }
    
    var operationAvailableInputs: [(name: String, desc: String)]  {
        let array = operationEntity.availableInputs?.allObjects
        return array!.map {
            let input = $0 as! OperationInput
            return (name: input.name!, desc: input.desc!)
        }
    }
    
    var operationRejectFloatingPoint: Bool { return (operationEntity.rejectFloatingPoint?.boolValue)! }
    var operationImage: UIImage? { return nil }
    
    func calculate (inputs: [String: Double]) -> [(name: String, from: String, result: String)]? {
        // TODO: implement calculate!
        return nil
    }
    
    init(entity: OperationEntity) {
        operationEntity = entity
    }
}