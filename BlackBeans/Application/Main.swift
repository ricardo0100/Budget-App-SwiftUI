//
//  Main.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 28/06/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

@main
struct Main: App {
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, Persistency.shared.context)
        }
    }
}
