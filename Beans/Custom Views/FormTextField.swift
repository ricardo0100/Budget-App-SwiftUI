//
//  FormTextField.swift
//  Beans
//
//  Created by Ricardo Gehrke on 29/11/20.
//

import SwiftUI

struct FormTextField: View {
    
    let fieldName: String?
    let placeholder: String
    let keyboardType: UIKeyboardType
    let useSecureField: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var text: String
    @Binding var error: String?
    
    init(fieldName: String? = nil,
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
        VStack(alignment: .leading) {
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
                if !useSecureField {
                    TextField(placeholder, text: $text)
                        .padding(.horizontal, 8)
                } else {
                    SecureField(placeholder, text: $text)
                        .padding(.horizontal, 8)
                }
            }
            if let error = error {
                Text(error).font(.caption2)
                    .foregroundStyle(Color.redText(for: colorScheme) ?? .red)
            }
        }
        .padding(.vertical, 4)
        .keyboardType(keyboardType)
    }
}

struct FormTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Form {
                FormTextField(
                    text: .constant("Ricardo"),
                    error: .constant(nil)
                )
                FormTextField(
                    placeholder: "Gehrke",
                    text: .constant(""),
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
            }.navigationTitle("Form")
        
            Form {
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
            }.preferredColorScheme(.dark)
        }
    }
}
