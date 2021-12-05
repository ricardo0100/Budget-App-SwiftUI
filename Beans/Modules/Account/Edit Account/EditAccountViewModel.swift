//
//  EditAccountViewModel.swift
//  Beans
//
//  Created by Ricardo Gehrke on 03/12/20.
//

import Foundation
import SwiftUI
import CoreData

class EditAccountViewModel: ObservableObject {
    
    @Published var title = ""
    @Published var name = ""
    @Published var nameError: String?
    @Published var color: String?
    
    private let context: NSManagedObjectContext
    private var account: Account?
    
    init(account: Account? = nil,
         context: NSManagedObjectContext = CoreDataController.shared.container.viewContext) {
        self.account = account
        self.context = context
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
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
