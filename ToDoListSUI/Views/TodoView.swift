//
//  ContentView.swift
//  ToDoListSUI
//
//  Created by Аня Беликова on 31.08.2024.
//

import SwiftUI

enum TaskTabName {
    case personal, external
}

struct TodoView: View {
    @StateObject private var dataManager = DataManager.shared
    @StateObject var baseVM = BaseVM.shared
    
    @State private var addNewTask = false
    @State private var taskName = ""
    @State private var taskDescription = ""
    @State private var selectedTask: TaskItem? = nil
    @State private var isDescriptionShown: Bool = false
    @State private var editingTask: TaskItem? = nil
    
    @State private var selectedTab = TaskTabName.external
    
    var body: some View {
        VStack {
            Text("TO-DO List")
                .font(.title)
                .fontWeight(.bold)
            
            Picker("Tab", selection: $selectedTab) {
                Text("External Tasks").tag(TaskTabName.external)
                Text("Personal Tasks").tag(TaskTabName.personal)
            }
            .padding(.leading)
            .padding(.trailing)
            .pickerStyle(.segmented)
            
            if selectedTab == .external {
                ExternalTasksView()
            } else {
                PersonalTasksView()
            }
            
        }
        .onAppear {
            Task {
                try await baseVM.fetchData()
            }
        }
        
    }
}

#Preview {
    TodoView()
}

