//
//  EditItemView.swift
//  Beans
//
//  Created by Ricardo Gehrke on 27/11/20.
//

import Combine
import SwiftUI
import CoreData

struct EditItemView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var viewModel: EditItemViewModel
    
    @State var isShowingSelectAccount: Bool = false
    @State var editAccount: Account?
    
    var body: some View {
        NavigationView {
            if viewModel.shouldShowNoAccountsError {
                VStack(spacing: 0) {
                    Text("No accounts created")
                        .font(.headline)
                    Button("Create account") {
                        editAccount = Account(context: viewContext)
                    }
                }.toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", action: viewModel.onTapCancel)
                    }
                }
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    FormTextField(fieldName: "Item name",
                                  text: $viewModel.name,
                                  error: $viewModel.nameError)
                    
                    FormCurrencyTextField(fieldName: "Value",
                                          value: $viewModel.value,
                                          error: .constant(nil))
                    
                    Spacer().frame(height: 6)
                    Text("Account")
                        .font(.headline)
                    let selectView = SelectAccountView(
                        selectedAccountIndex: $viewModel.selectedAccountIndex)
                    NavigationLink(destination: selectView) {
                        SelectAccountCell(account: $viewModel.selectedAccount)
                    }
                    Spacer()
                }
                .padding()
                .navigationTitle(viewModel.title)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", action: viewModel.onTapCancel)
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button("Save", action: viewModel.onTapSave)
                    }
                }
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .onDisappear {
            viewModel.onTapCancel()
        }
        .sheet(item: $editAccount) { item in
            EditAccountView(viewModel: EditAccountViewModel(account: $editAccount))
                .environment(\.managedObjectContext, viewContext)
        }
    }
}

struct EditItemView_Previews: PreviewProvider {
    
    static let item = Item(context: CoreDataController.preview.container.viewContext)
    static var previews: some View {
        Group {
            EditItemView(viewModel: EditItemViewModel(
                item: Binding.constant(item),
                context: CoreDataController.preview.container.viewContext)
            ).environment(\.managedObjectContext,
                       CoreDataController.preview.container.viewContext)
            EditItemView(viewModel: EditItemViewModel(
                item: Binding.constant(item),
                context: CoreDataController.preview.container.viewContext)
            ).preferredColorScheme(.dark).environment(\.managedObjectContext,
                           CoreDataController.preview.container.viewContext)
        }
    }
}
