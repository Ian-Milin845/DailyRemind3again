//
//  DataStore.swift
//  DailyRemind3
//
//  Created by:
//  Ian Milin
//  Veronica Miranda
//  Jaqueline Martinez
//  Jayden Hixon
//

import Foundation
import SwiftUI
import Combine

/*
let newItem = ToDoListItem(
        id: newId,
        title: title,
        dueDate: dueDate.timeIntervalSince1970,
        createdDate: Date().timeIntervalSince1970,
        isDone: false
    )*/

class TaskStore : ObservableObject {
    @Published var tasks = [ToDoListItem]()
    
    @Published var title = ""
    @Published var dueDate = Date()
    @Published var showAlert = false
     
    init() {}
    
    func save() {
        guard canSave else {
            return
        }
        
        tasks[tasks.count].title = title
        tasks[tasks.count - 1].dueDate = dueDate.timeIntervalSince1970
        // Save model
        
    }
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        guard dueDate >= Date().addingTimeInterval(-86400) else {
            return false
        }
        
        return true
    }
}
