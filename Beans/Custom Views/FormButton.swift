//
//  FormButton.swift
//  Beans
//
//  Created by Ricardo Gehrke on 13/02/21.
//

import SwiftUI

struct FormButton: View {
    
    let action: () -> Void
    let text: String
    @Binding var disabled: Bool
    @Binding var showProgressView: Bool
    
    var body: some View {
        let backgroundColor = disabled ? Color.gray.lighter() : Color.accentColor
        
        ZStack(alignment: .leading) {
            if showProgressView {
                ProgressView()
                    .transition(.scale)
                    .animation(.easeIn)
            }
            HStack {
                Spacer()
                Button(text) {
                    withAnimation {
                        action()
                    }
                }
                .disabled(disabled)
                .foregroundColor(.white)
                Spacer()
            }
        }.listRowBackground(backgroundColor)
    }
}

struct FormButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Form {
                FormButton(action: { },
                           text: "Tap me! 🐶",
                           disabled: .constant(true),
                           showProgressView: .constant(false))
            }
        }
    }
}
