//
//  BeansApp.swift
//  Beans
//
//  Created by Ricardo Gehrke on 25/11/20.
//

import SwiftUI
import Combine

@main
struct BeansApp: App {
    
    let persistence = PersistenceController.shared
    let userSettings = UserSettings()
    var cancellables: [AnyCancellable] = []
    @State var loggedUser: User?
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if loggedUser != nil {
                    TabsView()
                        .environment(\.managedObjectContext, persistence.container.viewContext)
                        .environmentObject(userSettings)
                } else {
                    SignUpView(viewModel: SignUpViewModel(userSettings: userSettings))
                        .environmentObject(userSettings)
                }
            }.onReceive(userSettings.userPublisher, perform: { user in
                loggedUser = user
            })
        }
    }
}
