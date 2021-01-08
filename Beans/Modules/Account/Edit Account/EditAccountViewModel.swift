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
    
    @Published var title = ""
    @Published var name = ""
    @Published var nameError: String?
    @Published var color: String?
    
    private let modelBinding: Binding<EditAccountModel?>
    private let context: NSManagedObjectContext
    
    init(modelBinding: Binding<EditAccountModel?>,
         context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.modelBinding = modelBinding
        self.context = context
    }
    
    func onAppear() {
        let account = modelBinding.wrappedValue?.account
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
        let account = modelBinding.wrappedValue?.account ?? Account(context: context)
        account.name = name
        account.color = color
        do {
            try context.save()
            modelBinding.wrappedValue = nil
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
