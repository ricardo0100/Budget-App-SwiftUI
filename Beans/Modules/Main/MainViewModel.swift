//
//  MainViewModel.swift
//  Beans
//
//  Created by Ricardo Gehrke on 26/01/21.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    
    @Published var userSessionIsActive: Bool
    
    private let userSession: UserSession
    private var cancellables: [AnyCancellable] = []
    
    init(userSession: UserSession = .shared) {
        self.userSession = userSession
        userSessionIsActive = userSession.user != nil
        subscribeToUserSessionPublisher()
    }
    
    private func subscribeToUserSessionPublisher() {
        userSession.userPublisher
            .sink { user in
                self.userSessionIsActive = user != nil
            }.store(in: &cancellables)
    }
}
