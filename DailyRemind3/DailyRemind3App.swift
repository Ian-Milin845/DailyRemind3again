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
    /*let modelContainer: ModelContainer
    init() {
        do {
            modelContainer = try ModelContainer(for: ToDoListItem.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }*/
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(/*modelContainer*/for: ToDoListItem.self)
    }
}
