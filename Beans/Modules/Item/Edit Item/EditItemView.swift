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
                VStack(spacing: 8) {
                    Text("No accounts created")
                        .font(.headline)
                    Button("Create account") {
                        editAccount = Account(context: viewContext)
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
                    NavigationLink("Select Account",
                                   destination: SelectAccountView(selectedAccountIndex: $viewModel.selectedAccountIndex))
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
        .onChange(of: editAccount, perform: { value in
            print(value)
        })
        .sheet(item: $editAccount) { item in
            EditAccountView(viewModel: EditAccountViewModel(account: $editAccount))
                .environment(\.managedObjectContext, viewContext)
        }
    }
}

struct EditItemView_Previews: PreviewProvider {
    
    static let item = Item(context: CoreDataController.preview.container.viewContext)
    static var previews: some View {
        EditItemView(viewModel: EditItemViewModel(item: Binding.constant(item),
                                                  context: CoreDataController.preview.container.viewContext))
            .environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
    }
}
