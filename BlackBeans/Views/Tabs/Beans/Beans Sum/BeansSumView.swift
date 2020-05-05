//
//  BeansSumView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 02/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct BeansSumView: View {
  
  private var type: BeansRequestType
  
  init(type: BeansRequestType) {
    self.type = type
  }
  
  var body: some View {
    let debits: Decimal = Persistency.shared.debitBeansSum(for: type)
    let credits: Decimal = Persistency.shared.creditBeansSum(for: type)
    let sum = credits - debits
    
    return VStack(alignment: .leading, spacing: 4) {
      HStack {
        Text("Debits:")
        Spacer()
        Text(debits.toCurrency ?? .empty).foregroundColor(.red)
      }
      HStack {
        Text("Credits:")
        Spacer()
        Text(credits.toCurrency ?? .empty).foregroundColor(.green)
      }
      HStack {
        Text("Total:").bold()
        Spacer()
        Text(sum.toCurrency ?? .empty)
          .bold()
          .foregroundColor(sum > 0 ? Color.green : Color.red)
      }
    }.padding()
  }
}
