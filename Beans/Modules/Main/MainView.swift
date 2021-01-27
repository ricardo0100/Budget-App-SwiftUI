//
//  MainView.swift
//  Beans
//
//  Created by Ricardo Gehrke on 26/01/21.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel = MainViewModel()
    
    var body: some View {
        if viewModel.userSessionIsActive {
            TabsView()
        } else {
            SignUpView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
