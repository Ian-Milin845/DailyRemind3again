//
//  NewItemView.swift
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

struct EditItemView: View {
    //@Environment(\.modelContext) var modelContext
    @Bindable var toDoListItem: ToDoListItem
    @Binding var editingItemPresented: Bool
    @State var showAlert: Bool = false
    @State var newTitle: String
    @State private var newDueDate: Date = .now.addingTimeInterval(3600)
    //toDoListItem.dueDate = newDueDate.timeIntervalSince1970
    
    var body: some View {
        VStack {
            Text("Edit Task")
                .font(.system(size: 32))
                .bold()
                .padding()
            
            Form {
                // Title
                TextField("Title", text: $newTitle /*$toDoListItem.title*/)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                // Due Date
                DatePicker("Due Date", selection: $newDueDate /*$toDoListItem.dueDate*/)
                    .datePickerStyle(DefaultDatePickerStyle())
                    /*.onChange(of: newDueDate) {
                        toDoListItem.dueDate = newDueDate.timeIntervalSince1970
                    }*/
                
                // Button
                TLButton(
                    title: "Save",
                    background: .purple
                ) {
                    if canSave {
                        // modelContext.insert(ToDoListItem(title: newTitle, dueDate: newDueDate))
                        toDoListItem.title = newTitle
                        toDoListItem.dueDate = newDueDate.timeIntervalSince1970
                        editingItemPresented = false
                    } else {
                        showAlert = true
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"),
                      message: Text("Please fill in all fields and select due date that is today or newer"))
            }
        }
    }
    
    var canSave: Bool {
        guard /*!toDoListItem.title*/!newTitle.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        //guard toDoListItem.dueDate.timeIntervalSince1970 >= Date().addingTimeInterval(-86400).timeIntervalSince1970 else {
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
        let example = ToDoListItem(title: "Example ToDoListItem"/*, createdDate: Date.now.timeIntervalSince1970*/)
        return EditItemView(toDoListItem: example,
            editingItemPresented: Binding(
                get: {
                    return true
                },
                set: { _ in
                    
                }), newTitle: "Example ToDoListItem"/*, newTitle: Binding (
                    get: {
                        return "Example ToDoListItem"
                    },
                    set: { _ in
                        
                    })*/)
        .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
