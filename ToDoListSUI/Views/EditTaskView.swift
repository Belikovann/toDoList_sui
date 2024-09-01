//
//  EditTaskView.swift
//  ToDoListSUI
//
//  Created by Аня Беликова on 31.08.2024.
//

import SwiftUI

struct EditTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: DataManager
    
    @State var editingTask: TaskItem
    var closeSheet: () -> Void
//    var save: () -> Void
    
    private var taskDescription: Binding<String> {
           Binding<String>(
               get: {
                   editingTask.description ?? ""
               },
               set: { newValue in
                   editingTask.description = newValue
               }
           )
       }

    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 10) {
                Button(action: closeSheet) {
                    Text("Cancel")
                }
                .padding()
                
                Spacer()
                
                VStack(alignment: .center, spacing: 15) {
                    TextField("Task Name", text: $editingTask.todo)
                    TextField("Task Description", text: taskDescription)
                    Button(action: {
                        editDataTask()
                        closeSheet()
                    }) {
                        Text("Save")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .font(.title2)
                .textFieldStyle(.roundedBorder)
                .padding()
                
                Spacer()
            }
        }
    }
    
    func editDataTask() {
        
        dataManager.editAndUpdateTask(editingTask)
    }
}
//
//
//#Preview {
//    EditTaskView()
//}
