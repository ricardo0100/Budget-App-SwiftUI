//
//  CategoriesOverview.swift
//  Beans
//
//  Created by Ricardo Gehrke Filho on 12/12/21.
//

import SwiftUI

struct CategoriesOverview: View {
    
    @ObservedObject var viewModel: CategoriesOverviewViewModel
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                PieChartView(values: viewModel.values.reduce(into: [:], { partialResult, values in
                    partialResult[values.color] = values.value
                }), radius: geo.size.width / 5)
                
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(0..<viewModel.values.count) { i in
                        HStack {
                            Circle()
                                .foregroundColor(viewModel.values[i].color)
                                .frame(width: 8, height: 8)
                            Text("\(viewModel.values[i].label) (\(viewModel.values[i].value.toIntegerPercentString()))")
                                .lineLimit(1)
                                .font(.footnote)
                        }
                    }
                }
            }.position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }
}

struct CategoriesOverview_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                CategoriesOverview(viewModel: CategoriesOverviewViewModel(context: CoreDataController.preview.container.viewContext))
                    .frame(height: 180)
            }
            List {
                CategoriesOverview(viewModel: CategoriesOverviewViewModel(context: CoreDataController.preview.container.viewContext))
                    .frame(height: 180)
            }.preferredColorScheme(.dark)
        }
    }
}
