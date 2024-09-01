//
//  DataManager.swift
//  ToDoListSUI
//
//  Created by Аня Беликова on 31.08.2024.
//

import Foundation
import CoreData
import SwiftUI


enum DataManagerType {
    case regular, creating, testing
}

class DataManager: NSObject, ObservableObject {
    
    static let shared = DataManager(type: .regular)
    static let preview = DataManager(type: .creating)
    static let testing = DataManager(type: .testing)
    
    @Published var tasks: [TaskItem] = []
    
    private var managedObjectContext: NSManagedObjectContext
    private let tasksFRC: NSFetchedResultsController<TaskEntity>
    
    private init(type: DataManagerType) {
        switch type {
        case .regular:
            let persistenceStorage = PersistenceStorage()
            self.managedObjectContext = persistenceStorage.context
        case .creating:
            let persistenceStorage = PersistenceStorage(inMemory: true)
            self.managedObjectContext = persistenceStorage.context
            for i in 0..<10 {
                let newTask = TaskEntity(context: managedObjectContext)
                newTask.id = Int64(i)
                newTask.name = "Task \(i)"
                newTask.isCompleted = false
                newTask.dateAdded = Date()
            }
            try? self.managedObjectContext.save()
        case .testing:
            let persistenceStorage = PersistenceStorage(inMemory: true)
            self.managedObjectContext = persistenceStorage.context
        }
        
        let taskFR: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        taskFR.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]
        tasksFRC = NSFetchedResultsController(fetchRequest: taskFR,
                                              managedObjectContext: managedObjectContext,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        
        super.init()
        
        tasksFRC.delegate = self
        try? tasksFRC.performFetch()
        if let newTasks = tasksFRC.fetchedObjects {
            self.tasks = newTasks.map { TaskItem(taskEntity: $0) }
        }
    }
    
    func saveData() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print("Changes saved successfully.")
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
    
    func addTask(_ task: TaskItem) {
        let taskEntity = TaskEntity(context: managedObjectContext)
        update(taskEntity: taskEntity, from: task)
        saveData()
    }
    
    func editAndUpdateTask(_ task: TaskItem) {
        let predicate = NSPredicate(format: "id = %d", task.id)
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = predicate
        
        do {
            let results = try managedObjectContext.fetch(request)
            if let taskEntity = results.first {
                update(taskEntity: taskEntity, from: task)
                saveData()
                print("должно сохранить")
            }
        } catch {
            print("Failed to fetch TaskEntity to update: \(error)")
        }
    }
    
    
    func deleteTask(id: Int) {
        let predicate = NSPredicate(format: "id = %d", id)
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = predicate
        
        do {
            let results = try managedObjectContext.fetch(request)
            if let taskEntity = results.first {
                managedObjectContext.delete(taskEntity)
                saveData()
            }
        } catch {
            print("Failed to fetch TaskEntity to delete: \(error)")
        }
    }
    
    func getTask(with id: Int) -> TaskItem? {
        return tasks.first { $0.id == id }
    }
    
    private func update(taskEntity: TaskEntity, from task: TaskItem) {
        taskEntity.id = Int64(task.id)
        taskEntity.name = task.todo
        taskEntity.isCompleted = task.completed
        taskEntity.dateAdded = task.dateAdded
        taskEntity.taskDescription = task.description
    }
    
    func updateStatusTask(id: Int, isCompleted: Bool) {
            let predicate = NSPredicate(format: "id = %d", id)
            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            request.predicate = predicate
            
            do {
                let results = try managedObjectContext.fetch(request)
                if let taskEntity = results.first {
                    taskEntity.isCompleted = isCompleted
                    saveData()
                    
                    //  update UI
                    if let index = tasks.firstIndex(where: { $0.id == id }) {
                        tasks[index].completed = isCompleted
                    }
                }
            } catch {
                print("Failed to fetch TaskEntity to update status: \(error)")
            }
        }
}

extension DataManager: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let newTasks = controller.fetchedObjects as? [TaskEntity] {
            self.tasks = newTasks.map { TaskItem(taskEntity: $0) }
        }
    }
}

extension TaskItem {
    init(taskEntity: TaskEntity) {
        self.id = Int(taskEntity.id)
        self.todo = taskEntity.name ?? ""
        self.completed = taskEntity.isCompleted
        self.userId = Int(taskEntity.userId)
        self.dateAdded = taskEntity.dateAdded
        self.description = taskEntity.taskDescription
    }
}
