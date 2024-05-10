//
//  ContentView.swift
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
import Foundation
struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \ToDoListItem.dueDate) var toDoListItems: [ToDoListItem]
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var newToDo : String = ""
    @State var showingEditItemView = false
    @State var editToDoListItem: ToDoListItem?
    var searchBar : some View {
        HStack {
            TextField("Enter in a new task", text: self.$newToDo)
            Button {
                addNewToDo()
                showingEditItemView = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }
    var body: some View {
        NavigationStack() {
            searchBar.padding()
            List {
                ForEach(toDoListItems) { toDoListItem in
                    HStack {
                        Button {
                            editToDoListItem = toDoListItem
                            showingEditItemView = true
                        } label: {
                            VStack(alignment: .leading) {
                                Text(toDoListItem.title)
                                Text(
                                    "\(toDoListItem.presentInterval)\(Date(timeIntervalSince1970: toDoListItem.dueDate).formatted(Date.FormatStyle().weekday(.short))), \(Date(timeIntervalSince1970: toDoListItem.dueDate).formatted(date: .numeric , time: .standard))"
                                )
                                .font(.caption)
                                .foregroundColor(Color(.secondaryLabel))
                            }
                        }
                        .buttonStyle(.plain)
                        Spacer()
                        VStack(alignment: .trailing) {
                            Button {
                                toDoListItem.isDone = !toDoListItem.isDone
                                if !toDoListItem.isDone && toDoListItem.dueDate <= Date().timeIntervalSince1970 {
                                    toDoListItem.statusUpdate = "Past Due"
                                } else if toDoListItem.isDone {
                                    toDoListItem.statusUpdate = "done"
                                } else {
                                    toDoListItem.statusUpdate = " "
                                }
                            } label: {
                                Image(systemName: toDoListItem.isDone ? "checkmark.square.fill" : "square")
                            }
                            
                            Text(toDoListItem.statusUpdate)
                                .frame(height: 20.0)
                                .onReceive(timer) {_ in
                                    if !toDoListItem.isDone && toDoListItem.dueDate <= Date().timeIntervalSince1970 {
                                        toDoListItem.statusUpdate = "Past Due"
                                    } else if toDoListItem.isDone {
                                        toDoListItem.statusUpdate = "done"
                                    } else {
                                        toDoListItem.statusUpdate = ""
                                    }
                                }
                        }
                        
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Reminders")
            .navigationBarItems(trailing: EditButton())
            .sheet(isPresented: $showingEditItemView) {
                EditItemView(
                    toDoListItem: editToDoListItem!,
                    editingItemPresented: $showingEditItemView,
                    selectedCategory: IntervalCategory(rawValue: editToDoListItem!.interval)!,
                    newTitle: editToDoListItem!.title
                )
                .onDisappear {
                    if !canRemain {
                        modelContext.delete(editToDoListItem!)
                    }
                }
            }
            
        }
    }
    func addNewToDo() {
        editToDoListItem = ToDoListItem(title: newToDo)
        modelContext.insert(editToDoListItem!)
        self.newToDo = ""
        //Ad auto generated id in the future.
    }
    func delete(at offsets : IndexSet) {
        for index in offsets {
            let toDoListItem = toDoListItems[index]
            UNUserNotificationCenter.current().removePendingNotificationRequests(
                withIdentifiers: [toDoListItem.title, "\(toDoListItem.title)2"]
            )
            modelContext.delete(toDoListItem)
        }
    }
    var canRemain: Bool {
        guard !editToDoListItem!.title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        guard editToDoListItem!.dueDate >= Date().addingTimeInterval(-86400).timeIntervalSince1970 else {
            return false
        }
        return true
    }
}
#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ToDoListItem.self, configurations: config)
        var count = 1
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            let reminder = ToDoListItem(
                title: "Reminder \(count)",
                dueDate: (Date().timeIntervalSince1970 + 31536000)
            )
            container.mainContext.insert(reminder)
            count = count + 1
            if (count == 20) {
                timer.invalidate()
            }
        }
        return ContentView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
