//
//  PieChartSliceView.swift
//  Beans
//
//  Created by Ricardo Gehrke Filho on 10/12/21.
//

import SwiftUI

struct PieChartSliceView: View {
    var center: CGPoint
    var radius: CGFloat
    var startDegree: Double
    var endDegree: Double
    var fillColor: Color
    
    var path: Path {
         var path = Path()
         path.addArc(center: center,
                     radius: radius,
                     startAngle: Angle(degrees: startDegree),
                     endAngle: Angle(degrees: endDegree),
                     clockwise: false)
         path.addLine(to: center)
         path.closeSubpath()
         return path
     }
    
    var body: some View {
        path.fill(fillColor)
    }
}

struct PieChartSliceView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartSliceView(center: .init(x: 100, y: 100), radius: 50, startDegree: 0, endDegree: 90, fillColor: .red)
    }
}
