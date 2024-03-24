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
    // @StateObject var viewModel = TaskStore()
    @Bindable var toDoListItem: ToDoListItem
    @Binding var editItemPresented: Bool
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack {
            Text("Edit Task")
                .font(.system(size: 32))
                .bold()
                .padding()
            
            Form {
                // Title
                TextField("Title", text: $toDoListItem.title)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                // Due Date
                DatePicker("Due Date", selection: $toDoListItem.dueDate)
                    .datePickerStyle(DefaultDatePickerStyle())
                
                // Button
                TLButton(
                    title: "Save",
                    background: .purple
                ) {
                    if canSave {
                        editItemPresented = false
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
        guard !toDoListItem.title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        guard toDoListItem.dueDate >= Date().addingTimeInterval(-86400) else {
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
            editItemPresented: Binding(
                get: {
                    return true
                },
                set: { _ in
                    
                }))
        .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
