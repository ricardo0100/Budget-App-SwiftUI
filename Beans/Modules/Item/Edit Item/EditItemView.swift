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
    
    @State var editAccountModel: EditAccountModel?
    
    var body: some View {
        NavigationView {
            if viewModel.shouldShowNoAccountsError {
                VStack(spacing: 8) {
                    Text("No accounts created")
                        .font(.headline)
                    Button("Create account") {
                        editAccountModel = EditAccountModel()
                    }
                }.toolbar(content: {
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                        Button("Cancel", action: viewModel.onTapCancel)
                    }
                })
            } else {
                Form {
                    FormTextField(keyboardType: .default,
                                  placeholder: "Item name",
                                  text: $viewModel.name,
                                  error: $viewModel.nameError,
                                  useSecureField: false)
                    
                    HStack {
                        Text("Value").foregroundColor(.secondary).layoutPriority(1)
                        Spacer().layoutPriority(1)
                        CurrencyTextField(value: $viewModel.value)
                    }
                    
                    Picker(selection: $viewModel.selectedAccountIndex, label: Text("Account").foregroundColor(.secondary), content: {
                        ForEach(0..<viewModel.availableAccounts.count) {
                            SelectAccountCell(account: viewModel.availableAccounts[$0]).tag($0)
                        }
                    })
                }
                .navigationTitle(viewModel.title)
                .toolbar(content: {
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                        Button("Cancel", action: viewModel.onTapCancel)
                    }
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                        Button("Save", action: viewModel.onTapSave)
                    }
                })
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .onChange(of: editAccountModel, perform: { _ in
            viewModel.onAppear()
        })
        .sheet(item: $editAccountModel) { item in
            EditAccountView(viewModel: EditAccountViewModel(modelBinding: $editAccountModel))
                .environment(\.managedObjectContext, viewContext)
        }
    }
}

struct EditItemView_Previews: PreviewProvider {
    
    static let item = Item(context: CoreDataController.preview.container.viewContext)
    static var previews: some View {
        EditItemView(viewModel: EditItemViewModel(model: .constant(EditItemModel(item: item)),
                                                  context: CoreDataController.preview.container.viewContext))
            .environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
    }
}
