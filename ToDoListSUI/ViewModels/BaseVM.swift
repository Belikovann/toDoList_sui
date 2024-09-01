//
//  BaseVM.swift
//  ToDoListSUI
//
//  Created by Аня Беликова on 31.08.2024.
//
import Foundation
import Combine

@MainActor
final class BaseVM: ObservableObject {
    
    @Published var taskList: [TaskItem] = []
    
    static let shared = BaseVM(networkManager: NetworkManager.shared)
    var anyCancellable: AnyCancellable? = nil
 
    var networkManager: NetworkManager
    
    private init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchData() async throws {
        do {
            let tasks = try await networkManager.fetchData()
            DispatchQueue.main.async {
                self.taskList = tasks
            }
        } catch {
            print("Error fetching data:", error)
        }
    }
    
    
    func getTaskList() -> [TaskItem] {
        return taskList.sorted { ($0.id < $1.id) }
    }
    
    
}

