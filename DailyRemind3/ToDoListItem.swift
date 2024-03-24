//
//  ToDoListItem.swift
//  DailyRemind3
//
//  Created by:
//  Ian Milin
//  Veronica Miranda
//  Jaqueline Martinez
//  Jayden Hixon
//

import SwiftData
import Foundation

@Model
class ToDoListItem /*: Identifiable*/ {
    let id: String
    var title: String
    var dueDate: Date
    let createdDate: Date
    var isDone: Bool
    
    init(id: String = "", title: String = "", dueDate: Date = .now.addingTimeInterval(3600), createdDate: Date = .now, isDone: Bool = false) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.createdDate = createdDate
        self.isDone = isDone
    }
    
    func setDone(_ state: Bool) {
        isDone = state
    }
}
