//
//  ExternalTasksView.swift
//  ToDoListSUI
//
//  Created by Аня Беликова on 31.08.2024.
//

import SwiftUI

struct ExternalTasksView: View {
    @StateObject var baseVM = BaseVM.shared
    @StateObject var dateManager = DateManager.shared
    @StateObject var dataManager = DataManager.shared
    
    @State private var addNewTask = false
    @State private var taskName = ""
    @State private var taskDescription = ""
    @State private var selectedTask: TaskItem? = nil
    @State private var shownDescriptionTasks: Set<Int> = []

    var body: some View {
        ScrollView(showsIndicators: false) {
            if baseVM.getTaskList().isEmpty {
                VStack {
                    Spacer()
                    Text("no new tasks")
                        .padding()
                        .font(.title)
                    Spacer()
                }
            } else {
                ForEach(baseVM.getTaskList()) { task in
                    let randomDate = dateManager.randomDate(forYear: 2024)
                    
                    TaskItemView(
                        name: task.todo,
                        date: dateManager.formattedDate(randomDate),
                        isCompleted: task.completed,
                        statusMark: task.completed ? "checkmark.circle.fill" : "circle",
                        isShownDescription: Binding<Bool>(
                            get: { shownDescriptionTasks.contains(task.id) },
                            set: { isVisible in
                                if isVisible {
                                    shownDescriptionTasks.insert(task.id)
                                } else {
                                    shownDescriptionTasks.remove(task.id)
                                }
                            }
                        ),
                        description: "Task for user ID: \(task.userId)", 
                        updateStatus: {
                            dataManager.updateStatusTask(id: task.id, isCompleted: !task.completed)
                        }
                    )
                }
            }
        }
        .padding()
    }
}


#Preview {
    ExternalTasksView()
}
