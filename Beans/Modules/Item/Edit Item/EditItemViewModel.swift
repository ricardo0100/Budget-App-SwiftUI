//
//  EditItemViewModel.swift
//  Beans
//
//  Created by Ricardo Gehrke on 28/11/20.
//

import Foundation
import Combine
import CoreData
import SwiftUI

enum OperationType {
    case debit
    case credit
}

class EditItemViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var value: Decimal = 0
    @Published var title: String = ""
    @Published var nameError: String?
    @Published var selectedAccount: Account?
    @Published var selectedCategory: ItemCategory?
    @Published var operationType: OperationType = .debit
    @Published var dismiss: Bool = false
    var item: Item?
    
    private var cancellables = [AnyCancellable]()
    private let nameErrorMessage = "Name should not be empty"
    private let locale: Locale
    private let context: NSManagedObjectContext
    
    init(item: Item? = nil,
         context: NSManagedObjectContext = CoreDataController.shared.container.viewContext,
         locale: Locale = .current) {
        self.context = context
        self.locale = locale
        self.item = item
        
        clearErrors()
        updateFields()
    }
    
    func onTapSave() {
        nameError = name.isEmpty ? nameErrorMessage : nil
        if !name.isEmpty {
            saveItem()
        }
    }
    
    func onDisappear() {
        context.rollback()
    }
    
    private func saveItem() {
        let item = item ?? Item(context: context)
        item.name = name
        if operationType == .debit {
            item.value = NSDecimalNumber(decimal: -value)
        } else {
            item.value = NSDecimalNumber(decimal: value)
        }
        item.value = item.value
        item.account = selectedAccount
        item.category = selectedCategory
        item.timestamp = Date()
        do {
            try context.save()
            dismiss = true
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func clearErrors() {
        nameError = nil
    }
    
    private func updateFields() {
        title = item?.name ?? "New Item"
        name = item?.name ?? ""
        if let decimalValue = item?.value?.decimalValue {
            if decimalValue < 0 {
                value = -decimalValue
                operationType = .debit
            } else {
                value = decimalValue
                operationType = .credit
            }
        }
        selectedAccount = item?.account
        selectedCategory = item?.category
    }
}
