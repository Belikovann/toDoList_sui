//
//  EditTaskVM.swift
//  ToDoListSUI
//
//  Created by Аня Беликова on 31.08.2024.
//
import SwiftUI
import Combine

@MainActor
final class EditTaskVM: ObservableObject {
    
    @Published var editingTask: TaskItem
    private var dataManager: DataManager

    init(editingTask: TaskItem, dataManager: DataManager) {
        self.editingTask = editingTask
        self.dataManager = dataManager
    }
    
    func saveChanges() {
        if editingTask.id == 0 {
            dataManager.addTask(editingTask)
        } else {
            dataManager.editAndUpdateTask(editingTask)
        }
    }
}
