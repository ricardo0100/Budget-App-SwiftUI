//
//  EditAccountView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 02/03/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct EditAccountView: View {
  
  @ObservedObject var viewModel: EditAccountViewModel
  @Binding var isPresented: Bool
  
  var body: some View {
    let trailing = Button(action: {
      self.isPresented = !self.viewModel.save()
    }) {
      Text("Save")
    }
    return NavigationView {
      VStack {
        TextField("Name", text: self.$viewModel.name)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        Spacer()
      }
      .padding()
      .navigationBarTitle(self.viewModel.title)
      .navigationBarItems(trailing: trailing)
    }
  }
}
