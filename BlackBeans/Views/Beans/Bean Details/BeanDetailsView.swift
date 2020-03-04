//
//  BeanDetailsView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 24/02/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct BeanDetailsView: View {
  
  @ObservedObject var viewModel: BeanDetailsViewModel
  @State var isEditPresented = false
  
  var body: some View {
    let editViewModel = EditBeanViewModel()
    editViewModel.editingBean = viewModel.bean
    let destination = EditBeanView(editBeanViewModel: editViewModel, isPresented: self.$isEditPresented)
    let trailingButton = Button(action: {
      self.isEditPresented = true
    }) {
      Text("Edit")
    }
    
    return VStack {
      Text(viewModel.bean.name ?? .empty)
      Text(viewModel.bean.value?.decimalValue.toCurrency ?? .empty)
    }
    .sheet(isPresented: self.$isEditPresented, content: {
      destination
    })
    .navigationBarItems(trailing: trailingButton)
  }
}
