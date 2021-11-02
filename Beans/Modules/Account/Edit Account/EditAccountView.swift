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
            VStack(alignment: .leading, spacing: 0) {
                FormTextField(fieldName: "Account name",
                              text: $viewModel.name,
                              error: $viewModel.nameError)
                Text("Select a color")
                    .font(.headline)
                SelectColorView(selectedColor: $viewModel.color)
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.onCancel()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
                        viewModel.onSave()
                    }
                }
            }
            .padding()
            .navigationTitle(viewModel.title)
        }.onAppear(perform: viewModel.onAppear)
            .onDisappear {
                viewModel.onCancel()
            }
    }
}

struct EditAccountView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditAccountView(viewModel: EditAccountViewModel(account: .constant(nil)))
            EditAccountView(viewModel: EditAccountViewModel(account: .constant(nil)))
                .preferredColorScheme(.dark)
        }
    }
}
