import Foundation
import CoreData
import SwiftyJSON

class OperationEntity: NSManagedObject {

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?, name: String, rejectFloatingPoint: Bool) {
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.name = name
        self.rejectFloatingPoint = NSNumber(bool: rejectFloatingPoint)
        self.availableInputs = NSOrderedSet()
        self.results = NSOrderedSet()
    }
    
    func toJSON() -> JSON {
        var inputsJSON = [JSON]()
        for input in availableInputs! {
            inputsJSON.append((input as! OperationInput).toJSON())
        }
        
        var resultsJSON = [JSON]()
        for result in results! {
            resultsJSON.append((result as! OperationResult).toJSON())
        }
        
        let dict = [
            "name": JSON(self.name!),
            "rejectFloatingPoint": JSON(self.rejectFloatingPoint!.boolValue),
            "availableInputs": JSON(inputsJSON),
            "results": JSON(resultsJSON)
        ]
        return JSON(dict)
    }
}
