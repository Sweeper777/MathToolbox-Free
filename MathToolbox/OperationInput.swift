import Foundation
import CoreData

class OperationInput : NSManagedObject {
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?, name: String, desc: String, operation: OperationEntity) {
        self.init(entity: entity, insertInto: context)
        self.name = name
        self.desc = desc
        self.operation = operation
    }
}
