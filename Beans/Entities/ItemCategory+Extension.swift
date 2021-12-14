//
//  ItemCategory+Extension.swift
//  Beans
//
//  Created by Ricardo Gehrke Filho on 12/12/21.
//

import Foundation
import CoreData

extension ItemCategory {
    
    func sum() -> NSDecimalNumber {
        let expression = NSExpressionDescription()
        expression.expression =  NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "value")])
        expression.name = "sum"
        expression.expressionResultType = NSAttributeType.decimalAttributeType
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        fetchRequest.propertiesToFetch = [expression]
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Item.category), self)
        do {
            let results = try managedObjectContext?.fetch(fetchRequest)
            let resultMap = results?.first as? [String: NSDecimalNumber]
            return resultMap?["sum"] ?? 0
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
