//
//  ContentView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 05/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI
import CoreData

struct MainView: View {
  
  @FetchRequest(fetchRequest: Bean.allBeansFetchRequest()) var beans: FetchedResults<Bean>
  @State private var showAddBeanView: Bool = false
  
  var body: some View {
    NavigationView {
      VStack {
        List {
          ForEach(beans, id: \.self) {
            BeanCell(bean: $0)
          }
        }
        Spacer()
        HStack {
          Text("Total")
          Spacer()
          Text(Persistency.allBeansSum.toCurrency)
        }.padding()
      }.sheet(isPresented: self.$showAddBeanView) {
        AddBeanView(isPresenting: self.$showAddBeanView)
      }
      .navigationBarTitle("Everything")
      .navigationBarItems(trailing: Button(action: {
        self.showAddBeanView.toggle()
      }) {
        Image(systemName: "plus")
      })
    }
  }
}

struct BeanCell: View {
  
  @State var bean: Bean
  
  var body: some View {
    HStack {
      Text(bean.name ?? "")
      Spacer()
      Text(bean.valueWithCurrency)
    }
  }
  
}
