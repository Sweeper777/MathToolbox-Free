import Foundation
import CoreData

class OperationInput : NSManagedObject {
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?, name: String, desc: String, operation: OperationEntity) {
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.name = name
        self.desc = desc
        self.operation = operation
    }
}