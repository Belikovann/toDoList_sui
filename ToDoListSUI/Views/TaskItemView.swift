//
//  TaskItemView.swift
//  ToDoListSUI
//
//  Created by Аня Беликова on 31.08.2024.
//

import SwiftUI

struct TaskItemView: View {
    var name: String
    var date: String
    @State var isCompleted = false
    var statusMark: String
    @Binding var isShownDescription: Bool
    var description: String
    var updateStatus: () -> Void
    
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Button(action: {
                isCompleted.toggle()
                updateStatus()
                if isCompleted {
                    isShownDescription = false
                }
            }) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isCompleted ? .green : .gray)
            }
            .frame(width: 24, height: 24)
            
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(name)
                        .font(.callout)
                        .strikethrough(isCompleted)
                        .foregroundColor(isCompleted ? .gray : .black)
                        .lineLimit(3)
                    
                    Text(date)
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    if isShownDescription {
                        Text(description)
                            .font(.caption)
                            .lineLimit(11)
                    }
                }
                
                Spacer()
                
                Image(systemName: isShownDescription ? "chevron.down" : "chevron.right")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        isShownDescription.toggle()
                    }
                    .frame(width: 24, height: 24)
            }
        }
    }
}
