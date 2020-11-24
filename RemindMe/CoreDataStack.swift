//
//  CoreDataStack.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import Foundation
import CoreData

class CoreDataStack {
    private let modelName: String
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("\(#file), \(#function), \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            fatalError("\(#file), \(#function), \(error.localizedDescription)")
        }
    }
    
    init(modelName: String) {
        self.modelName = modelName
    }
}
