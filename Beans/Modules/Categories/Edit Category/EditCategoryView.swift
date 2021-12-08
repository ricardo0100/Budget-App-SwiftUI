//
//  EditCategory.swift
//  Beans
//
//  Created by Ricardo Gehrke Filho on 25/11/21.
//

import SwiftUI

struct EditCategoryView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: EditCategoryViewModel
    
    var body: some View {
        Form {
            Section {
                FormTextField(text: $viewModel.name,
                              error: $viewModel.nameError)
                
                NavigationLink(destination: SelectCategoryIconView(selectedSymbol: $viewModel.symbol), label: {
                    if let symbol = viewModel.symbol {
                        HStack {
                            Image(systemName: symbol)
                                .frame(width: 32)
                            Text("Change icon").foregroundColor(.secondary)
                        }
                    } else {
                        Text("Select an icon")
                            .foregroundColor(.secondary)
                    }
                })
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
        .onDisappear(perform: viewModel.onDisappear)
    }
}

struct EditCategory_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataController.preview.container.viewContext
        return Group {
            NavigationView {
                EditCategoryView(viewModel: .init(context: context))
            }
            NavigationView {
                EditCategoryView(viewModel: .init(context: context))
                    .preferredColorScheme(.dark)
            }
        }.environment(\.managedObjectContext, context)
    }
}
