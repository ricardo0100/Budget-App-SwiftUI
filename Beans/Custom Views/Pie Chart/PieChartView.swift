//
//  PieChart.swift
//  Beans
//
//  Created by Ricardo Gehrke Filho on 10/12/21.
//

import SwiftUI

struct PieChartView: View {
    
    struct SliceValues {
        let startDegree: Double
        let endDegree: Double
        let color: Color
    }
    
    private let radius: CGFloat
    private let values: [Color: Double]
    private var slices: [SliceValues]
    
    init(values: [Color: Double],
         radius: CGFloat) {
        self.radius = radius
        self.values = values
        
        let sum = values.map { $0.value }.reduce(0, +)
        var lastDegree: Double = 0
        let multiplier = Double(360) / sum
        
        slices = values.map {
            let end = multiplier * $0.value + lastDegree
            let slice = SliceValues(startDegree: lastDegree, endDegree: end, color: $0.key)
            lastDegree = end
            return slice
        }
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<slices.count) { i in
                PieChartSliceView(
                    center: .init(x: radius, y: radius),
                    radius: radius,
                    startDegree: slices[i].startDegree,
                    endDegree: slices[i].endDegree,
                    fillColor: slices[i].color)
            }
        }.frame(width: radius * 2, height: radius * 2)
    }
}

struct PizzaChart_Previews: PreviewProvider {
    static let values: [Color: Double] = [.red: 1, .green: 1, .blue: 2]
    
    static var previews: some View {
        Group {
            PieChartView(values: values, radius: 100)
            PieChartView(values: values, radius: 100)
                .preferredColorScheme(.dark)
        }
    }
}
