//
//  HomeView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 05/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI
import CoreData
import Combine

struct HomeView: View {
  
  @FetchRequest(fetchRequest: Persistency.allBeansFetchRequest)
  private var beans: FetchedResults<Bean>
  
  @State var isEditingBeanPresented: Bool = false
  @State var isBeanDetailsPresented: Bool = false
  
  init() {
    Log.debug("HomeView init")
  }
  
  var body: some View {
    let list = List {
      ForEach(beans, id: \.self) { bean in
        NavigationLink(destination: BeanDetailsView(viewModel: BeanDetailsViewModel(bean: bean))) {
          BeanCell(bean: bean)
        }
      }.onDelete { self.deleteBeans(in: $0) }
    }
    
    let sum = HStack {
      Text("Total")
      Spacer()
      Text(Persistency.allBeansSum.toCurrency ?? "")
    }.padding()
    
    let editButton = Button(action: {
      self.isEditingBeanPresented = true
    }) {
      Image(systemName: "plus")
    }
    
    return NavigationView {
      VStack {
        list
        Spacer()
        sum
      }
      .navigationBarTitle("Everything")
      .navigationBarItems(trailing: editButton)
    }
    .sheet(isPresented: self.$isEditingBeanPresented) { () -> EditBeanView in
      EditBeanView(editBeanViewModel: EditBeanViewModel(), isPresented: self.$isEditingBeanPresented)
    }
  }
  
  private func deleteBeans(in indexSet: IndexSet) {
    for index in indexSet {
      let bean = self.beans[index]
      try? Persistency.deleteBean(bean: bean)
    }
  }
}
