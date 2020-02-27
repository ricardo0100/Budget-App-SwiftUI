//
//  CurrencyMaskedTextField.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 01/02/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI
import UIKit

public struct CurrencyTextField: UIViewRepresentable {
  
  @Binding var decimalValue: Decimal
  
  private let textField = UITextField()
  private let delegate = Delegate()
  
  public func makeUIView(context: UIViewRepresentableContext<CurrencyTextField>) -> UITextField {
    textField.borderStyle = .roundedRect
    delegate.currencyTextField = self
    textField.delegate = delegate
    textField.keyboardType = .decimalPad
    return textField
  }
  
  public func updateUIView(_ textField: UITextField, context: UIViewRepresentableContext<CurrencyTextField>) {
    let text = decimalValue.toCurrency
    textField.text = text
  }
  
  private class Delegate: NSObject, UITextFieldDelegate {
    
    var currencyTextField: CurrencyTextField?
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
      
      let nsString = textField.text as NSString?
      var newString = nsString?.replacingCharacters(in: range, with: string) ?? .empty
      
//      print(newString)
      
      if let int = Int(newString.removeNonNumbers()) {
        let decimal = Decimal(int) / 100
        currencyTextField?.decimalValue = decimal
        textField.text = decimal.toCurrency
        currencyTextField?.makeCoordinator()
      }
      
      return false
    }
  }
}
