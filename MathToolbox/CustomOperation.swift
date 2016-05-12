import UIKit
import MathParser

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
        var result: [(name: String, from: String, result: String)] = []
        
        operationEntity.results?.forEach {
            let item = $0 as! OperationResult
            var evaluator = Evaluator(caseSensitive: false)
            evaluator.angleMeasurementMode = .Degrees
            let x = try? evaluator.evaluate(Expression(string: item.formula!), substitutions: inputs)
            
            if x != nil {
                let froms = findAllStringsInQuotes(string: item.formula!)
                let from = froms.joinWithSeparator(", ")
                let hasPi = item.formula!.lowercaseString.containsString("pi") || item.formula!.lowercaseString.containsString("π")
                result.append((item.name!, from, correctToSigFigAndPi(x!, hasPi)))
            }
        }
        
        if result.count == 0 {
            return nil
        } else {
            return result
        }
    }
    
    init(entity: OperationEntity) {
        operationEntity = entity
    }
}

func findAllStringsInQuotes(string string: String, quoteCharacter: Character = "'") -> [String] {
    var result = [String]()
    var shouldAddToCurrent = false
    var current = ""
    
    for char in string.characters {
        if char == quoteCharacter {
            if shouldAddToCurrent {
                shouldAddToCurrent = false
                result.append(current)
            } else {
                shouldAddToCurrent = true
                current = ""
            }
        } else {
            if shouldAddToCurrent {
                current += String(char)
            }
        }
    }
    
    return result
}