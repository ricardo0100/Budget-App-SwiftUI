//
//  SelectCategoryIconView.swift
//  Beans
//
//  Created by Ricardo Gehrke Filho on 27/11/21.
//

import SwiftUI

struct SelectCategoryIconView: View {
    
    @Binding var selectedSymbol: String?
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(Symbols.all, id: \.self) { symbol in
                    Button {
                        selectedSymbol = symbol
                        self.mode.wrappedValue.dismiss()
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 52, height: 52, alignment: .center)
                                .foregroundColor(selectedSymbol == symbol ? Color.accentColor : Color.gray)
                            Image(systemName: symbol)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 26, height: 26, alignment: .center)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                }
            }
        }
        .padding(.vertical)
        .navigationTitle("Select Icon")
    }
}

struct SelectCategoryIconView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            StatefulPreviewWrapper("car") {
                SelectCategoryIconView(selectedSymbol: $0)
            }
            StatefulPreviewWrapper("car") {
                SelectCategoryIconView(selectedSymbol: $0)
            }.preferredColorScheme(.dark)
        }.previewLayout(.fixed(width: 300, height: 320))
    }
}
