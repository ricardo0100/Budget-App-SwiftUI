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

class EditItemViewModel: ObservableObject {
    
    @Published var shouldShowNoAccountsError: Bool = false
    @Published var name: String = "" {
        didSet {
            shouldSkipNameIsEmptyValidation = false
        }
    }
    @Published var value: Decimal = 0
    @Published var title: String = ""
    @Published var nameError: String?
    @Published var availableAccounts: [Account] = []
    @Published var selectedAccount: Account?
    @Published var selectedAccountIndex: Int? {
        didSet {
            guard let index = selectedAccountIndex else {
                return
            }
            let account = availableAccounts[index]
            selectedAccount = account
        }
    }
    @Binding var item: Item?
    
    private var cancellables = [AnyCancellable]()
    private let nameErrorMessage = "Name should not be empty"
    private let scheduler: TestableSchedulerOf<RunLoop>
    private let locale: Locale
    private let context: NSManagedObjectContext
    private var shouldSkipNameIsEmptyValidation = true
    
    init(item: Binding<Item?>,
         context: NSManagedObjectContext = CoreDataController.shared.container.viewContext,
         locale: Locale = .current,
         scheduler: TestableSchedulerOf<RunLoop> = TestableScheduler(RunLoop.main)) {
        self.scheduler = scheduler
        self.context = context
        self.locale = locale
        self._item = item
    }
    
    func onTapSave() {
        shouldSkipNameIsEmptyValidation = false
        nameError = name.isEmpty ? nameErrorMessage : nil
        if !name.isEmpty {
            saveItem()
        }
    }
    
    func onTapCancel() {
        item = nil
        if context.hasChanges {
            context.rollback()
        }
    }
    
    func onAppear() {
        clearErrors()
        updateFields()
        shouldSkipNameIsEmptyValidation = true
        startErrorsTimers()
    }
    
    private func saveItem() {
        let index = selectedAccountIndex ?? 0
        let item = item ?? Item(context: context)
        item.name = name
        item.value = NSDecimalNumber(decimal: value)
        item.account = availableAccounts[index]
        item.timestamp = Date()
        do {
            try context.save()
            dismiss()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func dismiss() {
        item = nil
    }
    
    private func clearErrors() {
        nameError = nil
    }
    
    private func updateFields() {
        title = item?.name ?? "New Item"
        name = item?.name ?? ""
        value = item?.value?.decimalValue ?? 0
        availableAccounts = (try? context.fetch(Account.fetchRequest())) ?? []
        if let account = item?.account {
            selectedAccountIndex = availableAccounts.firstIndex(of: account) ?? 0
        }
        if availableAccounts.isEmpty {
            shouldShowNoAccountsError = true
        } else {
            shouldShowNoAccountsError = false
        }
    }
    
    private func startErrorsTimers() {
        $name
            .removeDuplicates()
            .debounce(for: .seconds(2), scheduler: scheduler)
            .map { input -> String? in
                if self.shouldSkipNameIsEmptyValidation { return nil }
                return input.isEmpty ? self.nameErrorMessage : nil
            }
            .assign(to: \.nameError, on: self)
            .store(in: &cancellables)
    }
}
