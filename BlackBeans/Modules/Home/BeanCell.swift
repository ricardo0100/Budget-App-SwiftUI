//
//  BeanCell.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 20/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct BeanCell: View {
  
  @State var bean: Bean
  
  var body: some View {
    HStack {
      Text(bean.name ?? "")
      Spacer()
      Text((bean.value ?? 0).decimalValue.toCurrency ?? "")
    }
  }
  
}
