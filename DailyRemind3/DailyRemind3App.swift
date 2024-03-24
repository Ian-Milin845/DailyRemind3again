//
//  DailyRemind3App.swift
//  DailyRemind3
//
//  Created by Ian Milin
//

import SwiftData
import SwiftUI

@main
struct DailyRemind3App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ToDoListItem.self)
    }
}
