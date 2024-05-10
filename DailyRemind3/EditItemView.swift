//
//  EditItemView.swift
//  DailyRemind3
//
//  Created by:
//  Ian Milin
//  Veronica Miranda
//  Jaqueline Martinez
//  Jayden Hixon
//

import SwiftData
import SwiftUI
import UserNotifications
struct EditItemView: View {
    @Bindable var toDoListItem: ToDoListItem
    @Binding var editingItemPresented: Bool
    @State var selectedCategory: IntervalCategory = .daily
    @State var showAlert: Bool = false
    @State var newTitle: String
    @State private var newDueDate: Date = .now.addingTimeInterval(3600)
    var body: some View {
        VStack {
            Text("Edit Task")
                .font(.system(size: 32))
                .bold()
                .padding()
            Form {
                // Title
                TextField("Title", text: $newTitle)
                    .textFieldStyle(DefaultTextFieldStyle())
                // Due Date
                DatePicker("Date Components", selection: $newDueDate)
                    .datePickerStyle(DefaultDatePickerStyle())
                Toggle("Repeat", isOn: $toDoListItem.repeating)
                if toDoListItem.repeating {
                    Picker("Interval", selection: $selectedCategory) {
                        ForEach(IntervalCategory.allCases) { category in
                            Text(category.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                // Button
                TLButton(
                    title: "Save",
                    background: .purple
                ) {
                    if canSave {
                        UNUserNotificationCenter.current().removePendingNotificationRequests(
                            withIdentifiers: [toDoListItem.title, "\(newTitle)2"]
                        )
                        toDoListItem.title = newTitle
                        toDoListItem.dueDate = newDueDate.timeIntervalSince1970
                        let content = UNMutableNotificationContent()
                        content.title = toDoListItem.title
                        content.sound = .default
                        let targetDate = Date(timeIntervalSince1970: toDoListItem.dueDate)
                        var trigger = UNCalendarNotificationTrigger(
                            dateMatching: Calendar.current.dateComponents(
                                [.year, .month, .day, .hour, .minute, .second],
                                from: targetDate
                            ),
                            repeats: toDoListItem.repeating
                        )
                        var request: UNNotificationRequest
                        if toDoListItem.repeating {
                            toDoListItem.interval = selectedCategory.rawValue
                            toDoListItem.presentInterval = "\(toDoListItem.interval), "
                            switch selectedCategory {
                            case.minutely:
                                trigger = UNCalendarNotificationTrigger(
                                    dateMatching: Calendar.current.dateComponents(
                                        [.second],
                                        from: targetDate
                                    ),
                                    repeats: true
                                )
                                break
                            case .daily:
                                request = UNNotificationRequest(
                                    identifier: "\(newTitle)2",
                                    content: content,
                                    trigger: trigger
                                )
                                UNUserNotificationCenter.current().add(
                                    request,
                                    withCompletionHandler: { error in
                                        if error != nil {
                                            print("something went wrong")
                                        }
                                    }
                                )
                                trigger = UNCalendarNotificationTrigger(
                                    dateMatching: Calendar.current.dateComponents(
                                        [.hour, .minute, .second],
                                        from: targetDate),
                                    repeats: true
                                )
                                break
                            case .weekly:
                                request = UNNotificationRequest(
                                    identifier: "\(newTitle)2",
                                    content: content,
                                    trigger: trigger
                                )
                                UNUserNotificationCenter.current().add(
                                    request,
                                    withCompletionHandler: { error in
                                        if error != nil {
                                            print("something went wrong")
                                        }
                                    }
                                )
                                trigger = UNCalendarNotificationTrigger(
                                    dateMatching: Calendar.current.dateComponents(
                                        [.weekday, .hour, .minute, .second],
                                        from: targetDate
                                    ),
                                    repeats: true
                                )
                                break
                            case .monthly:
                                request = UNNotificationRequest(
                                    identifier: "\(newTitle)2",
                                    content: content,
                                    trigger: trigger
                                )
                                UNUserNotificationCenter.current().add(
                                    request,
                                    withCompletionHandler: { error in
                                        if error != nil {
                                            print("something went wrong")
                                        }
                                    }
                                )
                                trigger = UNCalendarNotificationTrigger(
                                    dateMatching: Calendar.current.dateComponents(
                                        [.month, .weekday, .hour, .minute, .second],
                                        from: targetDate
                                    ),
                                    repeats: true
                                )
                                break
                            }
                        } else {
                            toDoListItem.interval = "Daily"
                            toDoListItem.presentInterval = ""
                        }
                        request = UNNotificationRequest(
                            identifier: newTitle,
                            content: content,
                            trigger: trigger
                        )
                        UNUserNotificationCenter.current().add(
                            request,
                            withCompletionHandler: { error in
                                if error != nil {
                                    print("something went wrong")
                                }
                            }
                        )
                        editingItemPresented = false
                    } else {
                        showAlert = true
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"),
                      message: Text("Please fill in all fields and select due date that is today or newer")
                )
            }
        }
    }
    var canSave: Bool {
        guard !newTitle.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        guard newDueDate.timeIntervalSince1970 >= Date().addingTimeInterval(-86400).timeIntervalSince1970 else {
            return false
        }
        return true
    }
}
#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ToDoListItem.self, configurations: config)
        let example = ToDoListItem(title: "Example ToDoListItem")
        return EditItemView(
            toDoListItem: example,
            editingItemPresented: Binding(
                get: {
                    return true
                },
                set: { _ in
                }
            ),
            newTitle: "Example ToDoListItem"
        )
        .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
