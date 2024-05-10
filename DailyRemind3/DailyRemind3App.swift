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
    private var delegate: AppDelegate = AppDelegate()
    init() {
        let center = UNUserNotificationCenter.current()
        center.delegate = delegate
        center.requestAuthorization(
            options: [.alert, .badge, .sound],
            completionHandler: { success, error in
                if success {
                    // schedule test
                    print("All set!")
                }
                else if let error = error {
                    print(error.localizedDescription)
                }
            }
        )
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ToDoListItem.self)
    }
}
