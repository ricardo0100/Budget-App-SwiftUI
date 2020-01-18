//
//  AddBeanView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 17/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct AddBeanView: View {
    
  @ObservedObject var viewModel: AddBeanViewModel = AddBeanViewModel()
  
  @Binding var isPresenting: Bool
  @State var showingAlert = false
  @State var alertMessage = ""
  
  var body: some View {
    NavigationView {
      VStack {
        TextField("Name", text: $viewModel.name)
        TextField("Value", text: $viewModel.value)
        Spacer()
      }.padding()
      .navigationBarTitle("New Bean")
      .navigationBarItems(leading: Button("Cancel") {
        self.isPresenting.toggle()
      }, trailing: Button("Save") {
        if let error = self.viewModel.createBean() {
          self.alertMessage = error.localizedDescription
          self.showingAlert = true
        } else {
          self.isPresenting.toggle()
        }
      })
      .alert(isPresented: $showingAlert) {
        Alert(title: Text("Hey!"), message: Text(alertMessage), dismissButton: .default(Text("Got it!")))
      }
    }
  }
  
}

class AddBeanViewModel: ObservableObject, Identifiable {
  
  @Published var name: String = ""
  @Published var value: String = ""
  
  func createBean() -> NSError? {
    let value = Decimal(string: self.value) ?? 0
    return Persistency.createBean(name: name, value: value)
  }

}
