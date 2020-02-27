//
//  BeanDetailsViewModel.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 24/02/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation
import Combine

class BeanDetailsViewModel: ObservableObject, Identifiable {
  
  @Published var bean: Bean
  
  init(bean: Bean) {
    self.bean = bean
  }
  
}
