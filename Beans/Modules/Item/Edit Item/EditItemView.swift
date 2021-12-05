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
        Form {
            FormTextField(placeholder: "Item Name",
                          text: $viewModel.name,
                          error: $viewModel.nameError)
            
            FormCurrencyTextField(value: $viewModel.value,
                                  error: .constant(nil))
            
            SelectAccountCellView(selectedAccount: $viewModel.selectedAccount)
            
            SelectCategoryCellView(selectedCategory: $viewModel.selectedCategory)
        }
        .navigationTitle(viewModel.title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Save", action: viewModel.onTapSave)
            }
        }
        .onDisappear(perform: viewModel.onDisappear)
        .onAppear(perform: viewModel.onAppear)
        .onDisappear {
            viewModel.onTapCancel()
        }
    }
}

struct EditItemView_Previews: PreviewProvider {
    
    static let item = Item(context: CoreDataController.preview.container.viewContext)
    static var previews: some View {
        Group {
            NavigationView {
                EditItemView(viewModel: EditItemViewModel(
                    item: item,
                    context: CoreDataController.preview.container.viewContext)
                )
            }
            
            NavigationView {
                EditItemView(viewModel: EditItemViewModel(
                    item: item,
                    context: CoreDataController.preview.container.viewContext)
                ).preferredColorScheme(.dark)
            }
        }.environment(\.managedObjectContext,
                       CoreDataController.preview.container.viewContext)
    }
}
