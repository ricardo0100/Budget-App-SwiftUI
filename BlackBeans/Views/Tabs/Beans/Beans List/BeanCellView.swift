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
        Text(bean.creation?.fullDateString ?? .empty).font(.footnote)
      }
    }
  }
}

struct BeanCellView_Previews: PreviewProvider {
  static var previews: some View {
    let account = try! Persistency.shared.createAccount(name: "Bank of Saint Denis")
    let category = try! Persistency.shared.createCategory(name: "Restaurants", remoteID: nil)
    let bean = try! Persistency.shared.createBean(name: "Lunch",
                                           value: 10.99,
                                           isCredit: false,
                                           remoteID: nil,
                                           account: account,
                                           category: category)
    return BeanCellView(bean: bean)
      .previewLayout(.fixed(width: 380, height: 80))
  }
}
