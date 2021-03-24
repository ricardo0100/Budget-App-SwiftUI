//
//  APISync.swift
//  Beans
//
//  Created by Ricardo Gehrke on 28/01/21.
//

import Foundation
import CoreData
import Combine

class Sync {
    
    enum Operation {
        case get, put, post
    }
    
    enum Status {
        case idle, inProgress, error
    }
    
    let status: CurrentValueSubject<Status, Never> = .init(.idle)
    
    private let api: API
    private let coreDataController: CoreDataController
    private var cancellables: [AnyCancellable] = []
    
    init(api: API, coreDataController: CoreDataController) {
        self.api = api
        self.coreDataController = coreDataController
        
    }
    
    func startSync() {
        status.value = .inProgress
        api
            .getResources()
            .tryMap { try self.saveAccounts($0) }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    break
                }
                do {
                    try self.coreDataController.container.viewContext.save()
                } catch {
                    self.status.value = .error
                }
                self.status.value = .idle
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    private func saveAccounts(_ accountsResponse: [AccountResponse]) throws {
        let context = coreDataController.container.newBackgroundContext()
        for apiAccount in accountsResponse {
            let account = try fetchAccount(with: apiAccount.id, in: context) ?? Account(context: context)
            account.name = apiAccount.name
            account.remoteID = Int64(apiAccount.id)
        }
        try context.save()
    }
    
    private func fetchAccount(with remoteID: Int, in context: NSManagedObjectContext) throws -> Account? {
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %d", "remoteID", Int64(remoteID))
        return try context.fetch(request).first
    }
}
