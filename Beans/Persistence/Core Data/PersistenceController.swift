//
//  PersistenceController.swift
//  Beans
//
//  Created by Ricardo Gehrke on 25/11/20.
//

import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController(inMemory: ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil)

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        var accounts: [Account] = []
        
        for i in 0..<3 {
            let newAccount = Account(context: viewContext)
            newAccount.name = "Bank \(i)"
            newAccount.color = ["#F45599", "#6259AA", "#A655AA", "#66F5FA", "#6005AA", "#3F55AA", "#64A500"].randomElement()
            accounts.append(newAccount)
        }
        
        for _ in 0..<20 {
            let newItem = Item(context: viewContext)
            let account = accounts.randomElement()
            newItem.name = "Item \(Int.random(in: 0...999)) in account \(account?.name ?? "")"
            newItem.value = NSDecimalNumber(value: Double.random(in: 0.01...100))
            newItem.account = account
            newItem.timestamp = Date()
        }
        
        let newAccount = Account(context: viewContext)
        newAccount.name = "Empty Account"
        newAccount.color = "#7799A0"
        accounts.append(newAccount)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Beans")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                //TODO: Handle error
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func deleteEverything() {
        do {
            let deleteItems = NSBatchDeleteRequest(fetchRequest: Item.fetchRequest())
            try container.persistentStoreCoordinator.execute(deleteItems, with: container.viewContext)
            let deleteAccounts = NSBatchDeleteRequest(fetchRequest: Account.fetchRequest())
            try container.persistentStoreCoordinator.execute(deleteAccounts, with: container.viewContext)
            try container.viewContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
