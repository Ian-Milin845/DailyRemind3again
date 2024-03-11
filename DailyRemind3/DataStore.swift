//
//  DataStore.swift
//  DailyRemind3
//
//  Created by Ian Milin on 3/10/24.
//

import Foundation
import SwiftUI
import Combine

struct Task : Identifiable {
    var id = String()
    var toDoItem = String()
    
    //Add more complicated stuff later if you want
    
}

class TaskStore : ObservableObject {
    @Published var tasks = [Task]()
}
