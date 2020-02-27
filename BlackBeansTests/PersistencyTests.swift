//
//  PersistencyTests.swift
//  BlackBeansTests
//
//  Created by Ricardo Gehrke on 26/02/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import XCTest
import CoreData

class PersistencyTests: XCTestCase {
  
  var persistency: Persistable!
  
  override func setUp() {
    persistency = PersistencyMock()
  }
  
  func testNoBeans() {
//    let result = try? persistency.context.fetch(persistency.allBeansFetchRequest)
//    XCTAssertEqual(result?.count, 0)
  }
  
  func testCreateBean() {
//    try? persistency.createBean(name: "Hey", value: 1.99, isCredit: false)
//    let result = try? persistency.context.fetch(persistency.allBeansFetchRequest)
//    XCTAssertEqual(result?.first?.name, "Hey")
  }
  
}
