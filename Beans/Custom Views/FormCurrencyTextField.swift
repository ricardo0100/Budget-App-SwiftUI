//
//  FormCurrencyTextField.swift
//  Beans
//
//  Created by Ricardo Gehrke on 01/11/21.
//

import SwiftUI

struct FormCurrencyTextField: View {
    
    let fieldName: String?
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var value: Decimal
    @Binding var error: String?
    
    init(fieldName: String? = nil,
         value: Binding<Decimal>,
         error: Binding<String?>) {
        self.fieldName = fieldName
        self._value = value
        self._error = error
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let fieldName = fieldName {
                Text(fieldName)
                    .fontWeight(.light)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .frame(height: 30)
                    .foregroundColor(.fieldBackgroundColor(for: colorScheme))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.red, lineWidth: error == nil ? 0 : 1)
                    )
                CurrencyTextField(value: $value).padding(.horizontal, 8)
            }
            if let error = error {
                Text(error).font(.caption2)
                    .foregroundColor(.red)
            }
        }.padding(.bottom, 4)
    }
}

struct FormCurrencyTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Form {
                FormCurrencyTextField(
                    fieldName: "Value",
                    value: .constant(1.99),
                    error: .constant(nil)
                )
                FormCurrencyTextField(
                    value: .constant(1.99),
                    error: .constant(nil)
                )
            }
            Form {
                FormCurrencyTextField(
                    fieldName: "Value",
                    value: .constant(1.99),
                    error: .constant(nil)
                )
            }.preferredColorScheme(.dark)
        }
    }
}
