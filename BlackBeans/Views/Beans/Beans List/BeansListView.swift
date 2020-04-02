//
//  BeansList.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 05/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI
import CoreData
import Combine

struct BeansListView: View {
  
  private var beansRequest: FetchRequest<Bean>
  private var beans: FetchedResults<Bean> { beansRequest.wrappedValue }
  
  init(type: BeansListType) {
    self.beansRequest = FetchRequest(fetchRequest: Persistency.shared.beansFetchRequest(type: type))
  }
  
  var body: some View {
    List {
      ForEach(beans, id: \.self) { bean in
        NavigationLink(destination: BeanDetailsView(viewModel: BeanDetailsViewModel(bean: bean))) {
          BeanCellView(bean: bean)
        }
      }.onDelete { self.deleteBeans(in: $0) }
    }
  }
  
  private func deleteBeans(in indexSet: IndexSet) {
    for index in indexSet {
      let bean = self.beans[index]
      try? Persistency.shared.deleteBean(bean: bean)
    }
  }
}
