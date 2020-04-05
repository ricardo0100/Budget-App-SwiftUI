//
//  EditCategoryView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 04/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct EditCategoryView: View {
  
  @ObservedObject var viewModel: EditCategoryViewModel
  
  var body: some View {
    let trailing = Button(action: self.viewModel.save) {
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
      .alert(item: self.$viewModel.alertMessage) { message in
        Alert(title: Text(message))
      }
    }
  }
}
