//
//  CategoriesOverviewViewModel.swift
//  Beans
//
//  Created by Ricardo Gehrke Filho on 12/12/21.
//

import Foundation
import SwiftUI
import CoreData

class CategoriesOverviewViewModel: NSObject, ObservableObject {
    
    struct ChartValues {
        let label: String
        let value: Double
        let color: Color
    }
    
    @Published var values: [ChartValues] = []
    
    let resultController: NSFetchedResultsController<ItemCategory>
    
    init(context: NSManagedObjectContext = CoreDataController.shared.container.viewContext) {
        let request = ItemCategory.fetchRequest()
        request.sortDescriptors = [.init(key: "name", ascending: true)]
        request.fetchLimit = 6
//        request.predicate = NSPredicate(format: "%K == %d", #keyPath(Item.value), 0)
        resultController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        super.init()
        
        resultController.delegate = self
        
        do {
            try resultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        updateValues()
    }
    
    private func updateValues() {
        let categories = resultController.fetchedObjects
        var colors = Color.chartColors
        values = categories?.map {
            ChartValues(
                label: $0.name ?? "",
                value: $0.sum().doubleValue,
                color: colors.removeFirst()
            )
        } ?? []
    }
}

extension CategoriesOverviewViewModel: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateValues()
    }
}
