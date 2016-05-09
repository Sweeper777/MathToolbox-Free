import Foundation
import CoreData


class OperationEntity: NSManagedObject {

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?, name: String, rejectFloatingPoint: Bool) {
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.name = name
        self.rejectFloatingPoint = NSNumber(bool: rejectFloatingPoint)
        self.availableInputs = NSSet()
        self.results = NSSet()
    }
}
