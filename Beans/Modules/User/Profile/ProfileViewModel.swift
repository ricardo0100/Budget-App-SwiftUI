//
//  ProfileViewModel.swift
//  Beans
//
//  Created by Ricardo Gehrke on 06/01/21.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    
    @Published var isEditing: Bool = false {
        didSet {
            editButtonText = isEditing ? "Done" : "Edit"
        }
    }
    @Published var editButtonText: String = "Edit"
    @Published var name: String = ""
    @Published var email: String = ""
    
    private var cancellables: [AnyCancellable] = []
    @Published var userSettings: UserSettings
    
    init(userSettings: UserSettings) {
        self.userSettings = userSettings
        userSettings
            .$user
            .sink { user in
                self.name = user?.name ?? ""
                self.email = user?.email ?? ""
            }.store(in: &cancellables)
    }
    
    func onTapLogout() {
        userSettings.deleteUser()
    }
}
