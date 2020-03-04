//
//  BeanCellView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 20/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct BeanCellView: View {
  
  @State var bean: Bean
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(bean.name ?? .empty)
        Text(bean.account?.name ?? .empty).font(.footnote)
      }
      Spacer()
      VStack(alignment: .trailing) {
        Text(bean.value?.decimalValue.toCurrency ?? .empty)
          .foregroundColor(bean.isCredit ? Color.green : Color.red)
        Text(bean.creationTimestamp?.relativeDay ?? .empty).font(.footnote)
      }
    }
  }
  
}
