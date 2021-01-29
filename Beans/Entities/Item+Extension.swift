//
//  Item+Extension.swift
//  Beans
//
//  Created by Ricardo Gehrke on 17/12/20.
//

import Foundation
import CoreData

extension Item {
    static var allItemsFetchRequest: NSFetchRequest<Item> {
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        return request
    }
}
