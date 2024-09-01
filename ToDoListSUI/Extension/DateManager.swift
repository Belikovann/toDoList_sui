//
//  DateManager.swift
//  ToDoListSUI
//
//  Created by Аня Беликова on 31.08.2024.
//

import Foundation

class DateManager: ObservableObject {
    
    static let shared = DateManager()

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    func randomDate(forYear year: Int) -> Date {
        let calendar = Calendar.current
        let startOfYear = calendar.date(from: DateComponents(year: year, month: 1, day: 1))!
        let endOfYear = calendar.date(from: DateComponents(year: year + 1, month: 1, day: 1))!
        
        let randomTimeInterval = Double.random(in: startOfYear.timeIntervalSince1970...endOfYear.timeIntervalSince1970)
        
        return Date(timeIntervalSince1970: randomTimeInterval)
    }
    
    func currentDate() -> Date {
            return Date()
        }
}

