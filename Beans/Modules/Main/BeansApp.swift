//
//  BeansApp.swift
//  Beans
//
//  Created by Ricardo Gehrke on 25/11/20.
//

import SwiftUI

@main
struct BeansApp: App {

    let persistence = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            TabsView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
