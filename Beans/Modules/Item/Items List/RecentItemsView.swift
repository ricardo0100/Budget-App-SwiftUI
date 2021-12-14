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
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                if items.isEmpty {
                    Text("No items")
                        .foregroundColor(.secondary)
                } else {
                    List {
                        TabView {
                            CategoriesOverview(viewModel: CategoriesOverviewViewModel())
                            AccountsOverview()
                            Text("")
                        }.listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .tabViewStyle(PageTabViewStyle())
                        .frame(height: 180)
                        Section {
                            ForEach(items) { item in
                                NavigationLink(destination: {
                                    EditItemView(viewModel: EditItemViewModel(item: item))
                                }, label: {
                                    ItemCell(item: item)
                                })
                            }.onDelete(perform: deleteItems)
                        }
                    }   
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    NavigationLink(destination: {
                        EditItemView(viewModel: EditItemViewModel())
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
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
        Group {
            NavigationView {
                RecentItemsView()
                    .environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
            }
            NavigationView {
                RecentItemsView()
                    .preferredColorScheme(.dark)
                    .environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
            }
            NavigationView {
                RecentItemsView()
                    .environment(\.managedObjectContext, CoreDataController.shared.container.viewContext)
            }
            NavigationView {
                RecentItemsView()
                    .preferredColorScheme(.dark)
                    .environment(\.managedObjectContext, CoreDataController.shared.container.viewContext)
            }
        }
    }
}
