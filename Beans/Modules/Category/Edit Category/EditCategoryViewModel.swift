//
//  EditCategoryViewModel.swift
//  Beans
//
//  Created by Ricardo Gehrke Filho on 25/11/21.
//

import Foundation
import SwiftUI
import CoreData

class EditCategoryViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var nameError: String?
    @Published var symbol: String?
    @Published var title: String = ""
    
    private let context: NSManagedObjectContext
    private var category: ItemCategory?
    
    init(category: ItemCategory? = nil,
         context: NSManagedObjectContext = CoreDataController.shared.container.viewContext) {
        self.category = category
        self.context = context
        title = category?.name ?? ""
        name = category?.name ?? ""
        symbol = category?.symbol
    }
    
    func onSave() {
        nameError = ""
        guard !name.isEmpty else {
            nameError = "Name field should not be empty"
            return
        }
        let category = category ?? ItemCategory(context: context)
        category.name = name
        category.symbol = symbol
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func onDisappear() {
        context.rollback()
    }
}
