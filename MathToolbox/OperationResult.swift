import Foundation
import CoreData


class OperationResult: NSManagedObject {

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?, formula: String, name: String, operation: OperationEntity) {
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.formula = formula
        self.name = name
        self.operation = operation
    }
}
