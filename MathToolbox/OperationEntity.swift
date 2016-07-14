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
        var inputsArr = [JSON]()
        for input in availableInputs! {
            inputsArr.append((input as! OperationInput).toJSON())
        }
        
        var resultsArr = [JSON]()
        for result in results! {
            resultsArr.append((result as! OperationResult).toJSON())
        }
        let inputsJSON = JSON(inputsArr)
        let resultsJSON = JSON(resultsArr)
        
        let dict = [
            "name": JSON(self.name!),
            "rejectFloatingPoint": JSON(self.rejectFloatingPoint!.boolValue),
            "availableInputs": inputsJSON,
            "results": resultsJSON
        ]
        return JSON(dict)
    }
}
