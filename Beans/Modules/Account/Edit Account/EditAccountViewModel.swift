//
//  EditAccountViewModel.swift
//  Beans
//
//  Created by Ricardo Gehrke on 03/12/20.
//

import Foundation
import Combine
import SwiftUI
import CoreData

class EditAccountViewModel: ObservableObject {
    
    @Published var title = "New Account"
    @Published var name = ""
    @Published var nameError: String?
    @Published var color: String?
    
    @Binding var account: Account?
    private let context: NSManagedObjectContext
    
    init(account: Binding<Account?>,
         context: NSManagedObjectContext = CoreDataController.shared.container.viewContext) {
        self._account = account
        self.context = context
    }
    
    func onAppear() {
        title = account?.name ?? "New Account"
        name = account?.name ?? ""
        color = account?.color
    }
    
    func onSave() {
        if name.isEmpty {
            nameError = "Name should not be empty"
            return
        } else {
            nameError = nil
        }
        let account = account ?? Account(context: context)
        account.name = name
        account.color = color
        do {
            try context.save()
            self.account = nil
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func onCancel() {
        account = nil
        if context.hasChanges {
            context.rollback()
        }
    }
}
