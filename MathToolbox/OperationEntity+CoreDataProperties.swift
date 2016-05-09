import Foundation
import CoreData

extension OperationEntity {

    @NSManaged var name: String?
    @NSManaged var rejectFloatingPoint: NSNumber?
    @NSManaged var availableInputs: NSSet?
    @NSManaged var results: NSSet?

}
