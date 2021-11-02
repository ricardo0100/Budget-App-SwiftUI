//
//  FormCurrencyTextField.swift
//  Beans
//
//  Created by Ricardo Gehrke on 01/11/21.
//

import SwiftUI

struct FormCurrencyTextField: View {
    
    let fieldName: String
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var value: Decimal
    @Binding var error: String?
    
    var fieldBackgroundColor: Color {
        colorScheme == .dark ?
        Color.white.darker(by: 0.8) :
        Color.gray.lighter(by: 0.35)
    }
    
    init(fieldName: String,
         value: Binding<Decimal>,
         error: Binding<String?>) {
        self.fieldName = fieldName
        self._value = value
        self._error = error
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(fieldName)
                .font(.headline)
            ZStack {
                Rectangle()
                    .foregroundColor(fieldBackgroundColor)
                    .cornerRadius(5)
                    .frame(height: 40)
                
                CurrencyTextField(value: $value)
                    .padding()
                    .frame(height: 40)
            }
            
            if let error = error {
                Text(error).font(.caption2)
                    .foregroundColor(.red)
            }
        }
    }
}

struct FormCurrencyTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FormCurrencyTextField(
                fieldName: "Value",
                value: .constant(1.99),
                error: .constant(nil)
            ).padding()
            Spacer()
        }
    }
}
