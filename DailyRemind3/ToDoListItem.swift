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
    // var id: String
    var title: String //var dueDate: Date //
    var dueDate: TimeInterval //let createdDate: Date //
    var createdDate: TimeInterval
    var isDone: Bool
    var statusUpdate: String = ""
    
    init(//id: String = "",
        title: String = "", //dueDate: Date = Date.now.addingTimeInterval(3600), //
        dueDate: TimeInterval = Date.now.addingTimeInterval(3600).timeIntervalSince1970, //createdDate: Date = Date.now, //
        createdDate: TimeInterval = Date.now.timeIntervalSince1970,
        isDone: Bool = false
    ) { //self.id = id
        self.title = title //
        self.dueDate = dueDate
        self.createdDate = createdDate
        self.isDone = isDone
        
        /*if /*self.dueDate <= Date().timeIntervalSince1970 &&*/ self.isDone {
            self.status = "Past Due"
        } else {
            self.status = "Not past Due"
        }*/
    }
    
    /*func setDone(_ state: Bool) {
        isDone = state
    }*/
}
