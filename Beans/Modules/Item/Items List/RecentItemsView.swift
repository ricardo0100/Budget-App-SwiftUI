//
//  RecentItemsView.swift
//  Beans
//
//  Created by Ricardo Gehrke on 25/11/20.
//

import SwiftUI
import CoreData

struct RecentItemsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var editItemModel: EditItemModel?
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationView {
            VStack {
                if items.isEmpty {
                    Text("No items")
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(items) { item in
                            ItemCell(item: item)
                                .onTapGesture {
                                    editItemModel = EditItemModel(item: item)
                                }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
            }.toolbar {
                HStack {
                    Button(action: {
                        editItemModel = EditItemModel()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(item: $editItemModel) { item in
            EditItemView(viewModel: EditItemViewModel(model: $editItemModel, context: viewContext))
                .environment(\.managedObjectContext, viewContext)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // TODO: Handle error
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecentItemsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
