//
//  NetworkManager.swift
//  ToDoListSUI
//
//  Created by Аня Беликова on 31.08.2024.
//

import Foundation

@MainActor
class NetworkManager: ObservableObject {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData() async throws -> [TaskItem] {
        let (data, _) = try await URLSession.shared.data(from: Link.taskUrl.url)
        let decoder = JSONDecoder()
        
        do {
            let todosResponse = try decoder.decode(Todos.self, from: data)
            return todosResponse.todos
        } catch {
            print("Error decoding JSON:", error)
            throw error
        }
    }
    
    enum Link {
        case taskUrl
        
        var url: URL {
            switch self {
            case .taskUrl:
                return URL(string: "https://dummyjson.com/todos")!
            }
        }
    }
}
