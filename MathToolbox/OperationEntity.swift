import Foundation
import CoreData

class OperationEntity: NSManagedObject {

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?, name: String, rejectFloatingPoint: Bool) {
        self.init(entity: entity, insertInto: context)
        self.name = name
        self.rejectFloatingPoint = NSNumber(value: rejectFloatingPoint)
        self.availableInputs = NSOrderedSet()
        self.results = NSOrderedSet()
    }
}
