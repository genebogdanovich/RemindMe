//
//  CoreDataHelper.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import Foundation
import CoreData

class CoreDataHelper: DBHelperProtocol {
    static let shared = CoreDataHelper()
    
    typealias Object = NSManagedObject
    typealias Predicate = NSPredicate
    
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    // MARK: - DBHelper Protocol
    
    func create(_ object: NSManagedObject) {
        do {
            try context.save()
        } catch {
            fatalError("\(#file), \(#function), \(error.localizedDescription)")
        }
    }
    
    func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
        let result = fetch(objectType, predicate: predicate, limit: 1)
        switch result {
        case .success(let reminders):
            return .success(reminders.first as? T)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func update(_ object: NSManagedObject) {
        do {
            try context.save()
        } catch {
            fatalError("\(#file), \(#function), \(error.localizedDescription)")
        }
    }
    
    func delete(_ object: NSManagedObject) {
        //
    }
    
    func fetch<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate? = nil, limit: Int? = nil) -> Result<[T], Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        if let limit = limit {
            request.fetchLimit = limit
        }
        
        do {
            let result = try context.fetch(request)
            return .success(result as? [T] ?? [])
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - CoreData
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RemindMe")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("\(#file), \(#function), \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    
    func saveContext() {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch let error as NSError {
            fatalError("\(#file), \(#function), \(error.localizedDescription)")
        }
    }
}
