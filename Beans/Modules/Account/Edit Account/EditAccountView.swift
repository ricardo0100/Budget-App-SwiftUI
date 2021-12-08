//
//  EditAccountView.swift
//  Beans
//
//  Created by Ricardo Gehrke on 03/12/20.
//

import SwiftUI

struct EditAccountView: View {
    
    @ObservedObject var viewModel: EditAccountViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section {
                FormTextField(placeholder: "Account name",
                              text: $viewModel.name,
                              error: $viewModel.nameError)
                SelectColorView(selectedColor: $viewModel.color)
            } footer: {
                HStack {
                    Spacer()
                    Button("Save") {
                        viewModel.onSave()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.callout)
                }
            }
        }
        .navigationTitle(viewModel.title)
    }
}

struct EditAccountView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                EditAccountView(viewModel: EditAccountViewModel(account: nil))
            }
            NavigationView {
                EditAccountView(viewModel: EditAccountViewModel(account: nil))
            }.preferredColorScheme(.dark)
        }
    }
}
