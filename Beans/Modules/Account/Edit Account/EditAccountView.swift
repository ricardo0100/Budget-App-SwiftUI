//
//  EditAccountView.swift
//  Beans
//
//  Created by Ricardo Gehrke on 03/12/20.
//

import SwiftUI

struct EditAccountView: View {
    
    @ObservedObject var viewModel: EditAccountViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    FormTextField(keyboardType: .default,
                                  placeholder: "Account name",
                                  text: $viewModel.name,
                                  error: $viewModel.nameError,
                                  useSecureField: false)
                }
                Section(header: Text("Color")) {
                    SelectColorView(selectedColor: $viewModel.color)
                }
            }
            .navigationTitle(viewModel.title)
            .toolbar(content: {
                Button("Save", action: {
                    viewModel.onSave()
                })
            })
        }.onAppear(perform: viewModel.onAppear)
    }
}

struct EditAccountView_Previews: PreviewProvider {
    static var previews: some View {
        EditAccountView(viewModel: EditAccountViewModel(account: .constant(nil)))
    }
}
