//
//  ToDoListSUIApp.swift
//  ToDoListSUI
//
//  Created by Аня Беликова on 31.08.2024.
//

import SwiftUI

@main
struct ToDoListSUIApp: App {
    let persistenceController = PersistenceStorage.shared

    var body: some Scene {
        WindowGroup {
            TodoView()
                .preferredColorScheme(.light)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
