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
import SwiftUI
enum IntervalCategory: String, CaseIterable, Identifiable {
    case minutely = "Minutely"
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    var id: IntervalCategory { self }
}
@Model
class ToDoListItem{
    var title: String
    var dueDate: TimeInterval
    var createdDate: TimeInterval
    var isDone: Bool
    var repeating: Bool = false
    var interval: String = "Daily"
    var presentInterval: String = ""
    var statusUpdate: String = ""
    init(
        title: String = "",
        dueDate: TimeInterval = Date.now.addingTimeInterval(3600).timeIntervalSince1970,
        createdDate: TimeInterval = Date.now.timeIntervalSince1970,
        isDone: Bool = false
    ) {
        self.title = title
        self.dueDate = dueDate
        self.createdDate = createdDate
        self.isDone = isDone
    }
}
