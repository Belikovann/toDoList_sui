//
//  PersonalTasksView.swift
//  ToDoListSUI
//
//  Created by Аня Беликова on 31.08.2024.
//

import SwiftUI

struct PersonalTasksView: View {
    @StateObject private var dataManager = DataManager.shared
    @StateObject var dateManager = DateManager.shared
    @State private var isTaskCompleted = false
    @State private var addNewTask = false
    @State private var isEditedTask = false
    @State private var taskName = ""
    @State private var taskDescription = ""
    @State private var selectedTask: TaskItem? = nil
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    if dataManager.tasks.isEmpty {
                        Text("There is nothing to do. You are free")
                    } else {
                        ForEach(dataManager.tasks) { task in
                            let taskDate = dateManager.formattedDate(task.dateAdded ?? dateManager.currentDate())
                            
                            TaskItemView(
                                name: task.todo,
                                date: taskDate,
                                isCompleted: task.completed,
                                statusMark: task.completed ? "checkmark.circle.fill" : "circle",
                                isShownDescription: Binding<Bool>(
                                    get: { selectedTask?.id == task.id },
                                    set: { isVisible in
                                        if isVisible {
                                            selectedTask = task
                                        } else if selectedTask?.id == task.id {
                                            selectedTask = nil
                                        }
                                    }
                                ),
                                description: task.description?.isEmpty == false ? task.description! : "no description",
                                updateStatus: {
                                    dataManager.updateStatusTask(id: task.id, isCompleted: !task.completed)
                                }
                            )
                            .swipeActions(allowsFullSwipe: false) {
                                Button(action: {
                                    selectedTask = task
                                    isEditedTask.toggle()
                                }) {
                                    Image(systemName: "pencil.tip.crop.circle")
                                }
                                .tint(.green)
                                
                                Button(action: {
                                    dataManager.deleteTask(id: task.id)
                                }) {
                                    Image(systemName: "bin.xmark")
                                }
                                .tint(.red)
                            }
                        }
                    }
                }
                .padding(.top)
                .padding(.bottom, 10)
                .listStyle(.plain)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        addNewTask.toggle()
                    }) {
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 42))
                        }
                        .frame(width: 24, height: 24)
                    }
                    .padding(.trailing, 30)
                }
            }
        }
        .sheet(isPresented: $addNewTask) {
            NewTaskView(taskName: $taskName,
                        taskDescription: $taskDescription,
                        isCompleted: $isTaskCompleted,
                        closeSheet: {
                            addNewTask = false
                        })
            .environmentObject(dataManager)
        }
        .sheet(isPresented: $isEditedTask) {
            if let task = selectedTask {
                EditTaskView(editingTask: task,
                             closeSheet: { isEditedTask = false }
                )
                .environmentObject(dataManager)
            }
        }
    }
}
