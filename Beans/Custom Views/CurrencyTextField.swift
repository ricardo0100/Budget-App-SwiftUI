//
//  CurrencyTextField.swift
//  Beans
//
//  Created by Ricardo Gehrke on 02/12/20.
//

import SwiftUI
import UIKit

struct CurrencyTextField: UIViewRepresentable {
    
    @Binding var value: Decimal
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .currency
        return formatter
    }()
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.keyboardType = .decimalPad
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = formatter.string(for: value)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        var currencyTextField: CurrencyTextField
        
        init(_ currencyTextField: CurrencyTextField) {
            self.currencyTextField = currencyTextField
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard
                let text = textField.text,
                let textRange = Range(range, in: text)
            else { return false }
            
            let newText = text.replacingCharacters(in: textRange, with: string)
            let onlyNumbers = newText.filter { $0.isNumber }
            let decimal = Decimal(string: onlyNumbers)
            currencyTextField.value = (decimal ?? 0) / 100

            let newPosition = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            return false
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            let newPosition = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
    }
}

struct CurrencyTextField_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            CurrencyTextField(value: .constant(0))
        }
    }
}
