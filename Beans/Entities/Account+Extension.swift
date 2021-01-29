//
//  Account+Extension.swift
//  Beans
//
//  Created by Ricardo Gehrke on 17/12/20.
//

import Foundation
import CoreData

extension Account {
    
    static var allAccountsFetchRequest: NSFetchRequest<Account> {
        let request = NSFetchRequest<Account>(entityName: "Account")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        return request
    }
    
    func sum() -> NSDecimalNumber {
        let expression = NSExpressionDescription()
        expression.expression =  NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "value")])
        expression.name = "sum"
        expression.expressionResultType = NSAttributeType.decimalAttributeType
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        fetchRequest.propertiesToFetch = [expression]
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Item.account), self)
        do {
            let results = try managedObjectContext?.fetch(fetchRequest)
            let resultMap = results?.first as? [String: NSDecimalNumber]
            return resultMap?["sum"] ?? 0
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func recentItems() -> [Item] {
        let fetch: NSFetchRequest<Item> = Item.fetchRequest()
        fetch.predicate = NSPredicate(format: "account == %@", self)
        fetch.fetchLimit = 3
        fetch.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        do {
            let result = try managedObjectContext?.fetch(fetch)
            return result ?? []
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
