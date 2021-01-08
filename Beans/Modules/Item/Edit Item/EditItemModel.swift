//
//  EditItemModel.swift
//  Beans
//
//  Created by Ricardo Gehrke on 05/12/20.
//

import Foundation

class EditItemModel: Identifiable {
    
    let item: Item?
    
    init(item: Item? = nil) {
        self.item = item
    }
}
