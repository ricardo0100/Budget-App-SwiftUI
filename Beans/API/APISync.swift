//
//  APISync.swift
//  Beans
//
//  Created by Ricardo Gehrke on 28/01/21.
//

import Foundation
import Combine

//enum APISyncResponse<T: Decodable> {
//
//}

class APISync {
    
    private let api: APIProtocol
    private let coreDataController: CoreDataController
    private var cancellables: [AnyCancellable] = []
    
    init(api: APIProtocol, coreDataController: CoreDataController) {
        self.api = api
        self.coreDataController = coreDataController
    }
    
    func start() {
        api
            .getAccounts(after: Date())
            .retry(3)
            .flatMap { _ in self.api.postAccounts(accounts: []) }
            .sink { completion in
                print(completion)
            } receiveValue: { accounts in
                print(accounts)
            }.store(in: &cancellables)
    }
}
