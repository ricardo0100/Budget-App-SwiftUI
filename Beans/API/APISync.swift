//
//  APISync.swift
//  Beans
//
//  Created by Ricardo Gehrke on 28/01/21.
//

import Foundation
import Combine

struct APISync {
    
    private let api: APIProtocol
    private let coreDataController: CoreDataController
    private var cancellables: [AnyCancellable] = []
    
    init(api: APIProtocol, coreDataController: CoreDataController) {
        self.api = api
        self.coreDataController = coreDataController
    }
    
    func start() {
        api.getAccounts(after: Date())
    }
}
