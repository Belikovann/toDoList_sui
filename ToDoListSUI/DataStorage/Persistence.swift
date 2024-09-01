//
//  Persistence.swift
//  ToDoListSUI
//
//  Created by Аня Беликова on 31.08.2024.
//
import SwiftUI
import CoreData

struct PersistenceStorage {
    static let shared = PersistenceStorage()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TaskList")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    
    var context: NSManagedObjectContext { container.viewContext }
        
        func saveContext () {
            if context.hasChanges {
                do {
                    try context.save()
                } catch let error as NSError {
                    NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
                }
            }
        }
}
