//
//  NewTaskView.swift
//  ToDoListSUI
//
//  Created by Аня Беликова on 31.08.2024.
//

import SwiftUI
import CoreData

struct NewTaskView: View {
    @Binding var taskName: String
    @Binding var taskDescription: String
    @Binding var isCompleted: Bool
    @State var showError = false
    var closeSheet: () -> Void
    
    @EnvironmentObject var dataManager: DataManager
    @StateObject var dateManager = DateManager.shared
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .bottom) {
                    Button(action: closeSheet) {
                        Text("Cancel")
                    }
                    
                    Spacer()
                    
                    Text("Task dated \(dateManager.formattedDate(dateManager.currentDate()))")
                        .foregroundColor(.gray)
                        .font(.caption2)
                }
                .padding()
                .padding()
                
                
                Spacer()
                
                VStack(alignment: .center, spacing: 15) {
                    VStack(alignment: .leading, spacing: 5) {
                        TextField("Enter task name", text: $taskName)
                        if showError {
                            Text("This is a required field")
                                .foregroundColor(.red)
                                .font(.caption2)
                        }
                        
                    }
                    
                    TextField("Enter task description", text: $taskDescription)
                    
                    Button(action: {
                        if !taskName.isEmpty {
                            addTask()
                            clearFields()
                            closeSheet()
                        } else {
                            showError = true
                            
                        }
                    }) {
                        Text("Save")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top)
                }
                .font(.title2)
                .textFieldStyle(.roundedBorder)
                .padding()
                
                Spacer()
            }
        }
    }
    
    private func clearFields() {
        taskName = ""
        taskDescription = ""
    }

    
    private func addTask() {
        let createdDay = dateManager.currentDate()
        
        let newTask = TaskItem(id: Int(Date().timeIntervalSince1970) + 1,
                               todo: taskName,
                               completed: isCompleted,
                               userId: 1,
                               dateAdded: createdDay,
                               description: taskDescription)
        
        dataManager.addTask(newTask)
    }
}

