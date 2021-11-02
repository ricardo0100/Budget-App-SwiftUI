//
//  FormTextField.swift
//  Beans
//
//  Created by Ricardo Gehrke on 29/11/20.
//

import SwiftUI

struct FormTextField: View {
    
    let fieldName: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    let useSecureField: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var text: String
    @Binding var error: String?
    
    var fieldBackgroundColor: Color {
        colorScheme == .dark ?
        Color.white.darker(by: 0.8) :
        Color.gray.lighter(by: 0.35)
    }
    
    init(fieldName: String,
         placeholder: String = "",
         keyboardType: UIKeyboardType = .default,
         useSecureField: Bool = false,
         text: Binding<String>,
         error: Binding<String?>) {
        self.fieldName = fieldName
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.useSecureField = useSecureField
        self._text = text
        self._error = error
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(fieldName)
                .font(.headline)
            ZStack {
                Rectangle()
                    .frame(height: 40)
                    .foregroundColor(fieldBackgroundColor)
                    .cornerRadius(5)
                if useSecureField {
                    SecureField(placeholder, text: $text).padding()
                } else {
                    TextField(placeholder, text: $text).padding()
                }
            }
            if let error = error {
                Text(error).font(.caption2)
                    .foregroundColor(.red)
            }
        }
        .keyboardType(keyboardType)
    }
}

struct FormTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(spacing: 0) {
                FormTextField(
                    fieldName: "Name",
                    text: .constant("Ricardo"),
                    error: .constant(nil)
                )
                
                FormTextField(
                    fieldName: "E-mail",
                    text: .constant("ric@r.do"),
                    error: .constant(nil)
                )
                
                FormTextField(
                    fieldName: "Password",
                    useSecureField: true,
                    text: .constant(""),
                    error: .constant("Inform a password")
                )
            }.padding()
            VStack(spacing: 0) {
                FormTextField(
                    fieldName: "Name",
                    text: .constant("Ricardo"),
                    error: .constant(nil)
                )
                
                FormTextField(
                    fieldName: "E-mail",
                    text: .constant("ric@r.do"),
                    error: .constant(nil)
                )
                
                FormTextField(
                    fieldName: "Password",
                    useSecureField: true,
                    text: .constant(""),
                    error: .constant("Inform a password")
                )
            }
            .padding()
            .preferredColorScheme(.dark)
        }
    }
}
