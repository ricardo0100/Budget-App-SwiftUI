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
  
  var someNumberProxy: Binding<String> {
    Binding<String>(
      get: {
        print(self.viewModel.value.toCurrency)
        return self.viewModel.value.toCurrency
      },
      set: {
        print($0)
        if let value = StringFormatter.currencyFormatter.number(from: $0) {
          self.viewModel.value = value.doubleValue
        }
      }
    )
  }
  
  var body: some View {
    NavigationView {
      VStack {
        TextField("Name", text: $viewModel.name)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        TextField("Value", text: someNumberProxy)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .keyboardType(.decimalPad)
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
  @Published var value: Double = 0
  
  func createBean() -> NSError? {
    return Persistency.createBean(name: name, value: Decimal(value))
  }

}
