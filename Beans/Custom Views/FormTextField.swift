//
//  FormTextField.swift
//  Beans
//
//  Created by Ricardo Gehrke on 29/11/20.
//

import SwiftUI

struct FormTextField: View {
    
    let placeholder: String
    @Binding var text: String
    @Binding var error: String?
    
    var body: some View {
        VStack {
            TextField(placeholder, text: $text)
            if let error = error {
                VStack(alignment: .leading) {
                    Rectangle().frame(height: 1)
                    Spacer().frame(height: 4)
                    Text(error).font(.caption2)
                }.foregroundColor(.red)
            }
        }
    }
}

struct FormTextField_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            FormTextField(placeholder: "Name",
                          text: .constant("Bananas 🍌"),
                          error: .constant(nil))
            FormTextField(placeholder: "Value",
                          text: .constant(""),
                          error: .constant("Name should no be empty"))
        }
    }
}
