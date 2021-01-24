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
    var cancellables: [AnyCancellable] = []
    
    @ObservedObject var userSettings = UserSettings()

    var body: some Scene {
        WindowGroup {
            Group {
                if userSettings.user != nil {
                    TabsView()
                        .environment(\.managedObjectContext, persistence.container.viewContext)
                        .environmentObject(userSettings)
                } else {
                    SignUpView(viewModel: SignUpViewModel(api: API(), userSettings: userSettings))
                        .environmentObject(userSettings)
                }
            }
        }
    }
}
