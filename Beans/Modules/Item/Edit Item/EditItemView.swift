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
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    
    @ObservedObject var viewModel: EditItemViewModel
    @State var isShowingSelectAccount: Bool = false
    @State var editAccount: Account?
    
    var body: some View {
        Form {
            FormTextField(placeholder: "Item Name",
                          text: $viewModel.name,
                          error: $viewModel.nameError)
            
            HStack {
                FormCurrencyTextField(value: $viewModel.value,
                                      error: .constant(nil))
                Circle()
                    .frame(width: 12, height: 12)
                    .foregroundColor(viewModel.operationType == .credit ?
                                     Color.greenText(for: colorScheme) : Color.redText(for: colorScheme))
                    .animation(.default, value: viewModel.operationType)
            }
            
            SelectAccountCellView(selectedAccount: $viewModel.selectedAccount)
            
            SelectCategoryCellView(selectedCategory: $viewModel.selectedCategory)
            
            Picker("", selection: $viewModel.operationType) {
                Text("Debit").tag(OperationType.debit)
                Text("Credit").tag(OperationType.credit)
            }.pickerStyle(.segmented)
        }
        .navigationTitle(viewModel.title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Save", action: {
                    viewModel.onTapSave()
                })
            }
        }
        .onDisappear(perform: viewModel.onDisappear)
        .onChange(of: viewModel.dismiss) { _ in
            presentationMode.wrappedValue.dismiss()
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
