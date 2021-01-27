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
    
    let persistence = CoreDataController.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
