//
//  ContentView.swift
//  BlackBeansWatch Extension
//
//  Created by Ricardo Gehrke on 01/06/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var scrollAmount = 0.0
    
    var body: some View {
        VStack {
            Text(Decimal(scrollAmount).toCurrency ?? .empty)
                .font(.headline)
                .focusable(true)
                .digitalCrownRotation($scrollAmount)
            Button(action: {
                print("🏳️‍🌈")
            }) {
                Text("Save")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
