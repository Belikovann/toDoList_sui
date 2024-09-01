//
//  Task.swift
//  ToDoListSUI
//
//  Created by Аня Беликова on 31.08.2024.
//

import SwiftUI

struct Todos: Codable {
    var todos: [TaskItem]
}

struct TaskItem: Codable, Identifiable {
    
    var id: Int
    var todo: String
    var completed: Bool
    var userId: Int
    var dateAdded: Date?
    var description: String?
    
    init(id: Int, todo: String, completed: Bool, userId: Int, dateAdded: Date, description: String?) {
        self.id = id
        self.todo = todo
        self.completed = completed
        self.userId = userId
        self.dateAdded = dateAdded
        self.description = description
    }
    
}



