//
//  PersistencyTests.swift
//  BlackBeansTests
//
//  Created by Ricardo Gehrke on 26/02/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import XCTest
import CoreData

@testable import BlackBeans

class PersistencyTests: XCTestCase {
  
  var persistency: Persistable!
  
  override func setUp() {
    persistency = Persistency(isTestEnvironment: true)
  }
  
  func testNoBeans() {
    let result = try? persistency.context.fetch(persistency.allBeansFetchRequest)
    XCTAssertEqual(result?.count, 0)
  }
  
  func testCreateBean() {
    try! persistency.createBean(name: "test", value: 1.99, isCredit: false)
    let result = try? persistency.context.fetch(persistency.allBeansFetchRequest)
    XCTAssertEqual(result?.first?.name, "test")
  }
  
  func testCreate2Beans() {
    try! persistency.createBean(name: "test1", value: 1.99, isCredit: false)
    try! persistency.createBean(name: "test2", value: 1.99, isCredit: false)
    let result = try? persistency.context.fetch(persistency.allBeansFetchRequest)
    XCTAssertEqual(result?.count, 2)
  }
  
  func testFetchOrderedByCreationDate() {
    try! persistency.createBean(name: "test1", value: 1.99, isCredit: false)
    try! persistency.createBean(name: "test2", value: 1.98, isCredit: false)
    try! persistency.createBean(name: "test3", value: 1.97, isCredit: false)
    let result = try? persistency.context.fetch(persistency.allBeansFetchRequest)
    XCTAssertEqual(result?[0].name, "test1")
    XCTAssertEqual(result?[1].name, "test2")
    XCTAssertEqual(result?[2].name, "test3")
  }
  
  func testDeleteBean() {
    try! persistency.createBean(name: "test1", value: 1.99, isCredit: false)
    let bean = try? persistency.context.fetch(persistency.allBeansFetchRequest).first
    try! persistency.deleteBean(bean: bean)
    let result = try? persistency.context.fetch(persistency.allBeansFetchRequest)
    XCTAssertEqual(result?.count, 0)
  }
  
  func testCreditSum() {
    try! persistency.createBean(name: "test1", value: 1.00, isCredit: true)
    try! persistency.createBean(name: "test2", value: 1.00, isCredit: true)
    try! persistency.createBean(name: "test2", value: 1.00, isCredit: false)
    XCTAssertEqual(persistency.creditBeansSum, 2.00)
  }
  
  func testDebitSum() {
    try! persistency.createBean(name: "test1", value: 1.00, isCredit: true)
    try! persistency.createBean(name: "test2", value: 1.00, isCredit: false)
    try! persistency.createBean(name: "test2", value: 1.00, isCredit: false)
    XCTAssertEqual(persistency.debitBeansSum, 2.00)
  }
  
  func testAllBeansSum() {
    try! persistency.createBean(name: "test1", value: 1.00, isCredit: true)
    try! persistency.createBean(name: "test2", value: 1.00, isCredit: false)
    try! persistency.createBean(name: "test2", value: 1.00, isCredit: false)
    XCTAssertEqual(persistency.allBeansSum, -1.00)
  }
  
}
