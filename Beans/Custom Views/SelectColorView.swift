//
//  SelectColorView.swift
//  Beans
//
//  Created by Ricardo Gehrke on 08/12/20.
//

import SwiftUI

struct SelectColorView: View {
    
    let colors = ["#FF3380", "#CCCC00", "#66E64D", "#4D80CC", "#9900B3",
                  "#E64D66", "#4DB380", "#FF4D4D", "#99E6E6", "#6666FF"]
    
    @Binding var selectedColor: String?
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [.init(.fixed(34))]) {
                ForEach(colors, id: \.self) { color in
                    ZStack {
                        Circle()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .foregroundColor(Color.from(hex: color))
                        Circle()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .foregroundColor(Color.white.opacity(0.85))
                            .scaleEffect(selectedColor == color ? 0.0 : 0.8)
                    }.onTapGesture {
                        withAnimation(.linear(duration: 0.25)) {
                            selectedColor = color
                        }
                    }
                }
            }
        }
    }
}

struct ColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            StatefulPreviewWrapper("#CCCC00") {
                SelectColorView(selectedColor: $0)
            }
        }
    }
}
