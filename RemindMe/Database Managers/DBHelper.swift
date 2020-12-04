//
//  DBHelper.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import Foundation

public protocol DBHelper {
    associatedtype Object
    associatedtype Predicate
    
    func create(_ object: Object)
    func fetch(_ objectType: Object.Type, predicate: Predicate?, limit: Int?) -> Result<[Object], Error>
    func fetchFirst(_ objectType: Object.Type, predicate: Predicate?) -> Result<Object?, Error>
    func fetch(_ objectType: Object.Type, atIndex index: IndexSet) -> Result<Object?, Error>
    func update(_ object: Object)
    func delete(_ object: Object)
}
