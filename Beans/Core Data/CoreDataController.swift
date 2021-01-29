//
//  CoreDataController.swift
//  Beans
//
//  Created by Ricardo Gehrke on 25/11/20.
//

import CoreData

class CoreDataController {
    
    static let shared = CoreDataController()
    
    static let preview: CoreDataController = {
        let controller = CoreDataController(inMemory: true)
        createPreviewContent(in: controller.container.viewContext)
        return controller
    }()
    
    static let tests = CoreDataController(inMemory: true)
    
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
            let context = container.viewContext
            let items = try context.fetch(Item.allItemsFetchRequest)
            items.forEach { context.delete($0) }
            
            let accounts = try context.fetch(Account.allAccountsFetchRequest)
            accounts.forEach { context.delete($0) }
            
            try container.viewContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

extension CoreDataController {
    
    private static func createPreviewContent(in context: NSManagedObjectContext) {
        var accounts: [Account] = []
        
        for i in 0..<3 {
            let newAccount = Account(context: context)
            newAccount.name = "Bank \(i)"
            newAccount.color = ["#F45599", "#6259AA", "#A655AA", "#66F5FA", "#6005AA", "#3F55AA", "#64A500"].randomElement()
            accounts.append(newAccount)
        }
        
        for _ in 0..<20 {
            let newItem = Item(context: context)
            let account = accounts.randomElement()
            newItem.name = "Item \(Int.random(in: 0...999)) in account \(account?.name ?? "")"
            newItem.value = NSDecimalNumber(value: Double.random(in: 0.01...100))
            newItem.account = account
            newItem.timestamp = Date()
        }
        
        let newAccount = Account(context: context)
        newAccount.name = "Empty Account"
        newAccount.color = "#7799A0"
        accounts.append(newAccount)
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
