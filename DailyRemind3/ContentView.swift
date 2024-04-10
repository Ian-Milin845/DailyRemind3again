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
//import Combine

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \ToDoListItem.dueDate) var toDoListItems: [ToDoListItem]
    //@State private var path = [ToDoListItem]()
    @State var newToDo : String = ""
    @State var showingEditItemView = false
    @State var savedItem = true
    @State var editToDoListItem: ToDoListItem?
    
    var searchBar : some View {
        HStack {
            TextField("Enter in a new task", text: self.$newToDo)
            Button {
                // Action
                addNewToDo()
                showingEditItemView = true
                savedItem = false
            } label: {
                Image(systemName: "plus")
            }
        }
    }
    
    var body: some View {
        NavigationStack(/*path: $path*/) {
            searchBar.padding()
            List {
                /*Button {
                 
                 } label: {*/
                ForEach(toDoListItems) { toDoListItem in
                    //NavigationLink(value: toDoListItem) {
                    HStack(){
                        VStack(alignment: .leading) {
                            Text(toDoListItem.title)
                                
                            
                            Text(Date(timeIntervalSince1970: toDoListItem.dueDate).formatted(date: .numeric, time: .standard))
                            //Text(toDoListItem.dueDate.formatted(date: .numeric, time: .standard))
                                .font(.caption)
                                .foregroundColor(Color(.secondaryLabel))
                            
                        }
                        
                        
                        
                        
                        
                        //Spacer()
                        
                        Button {
                            toDoListItem.isDone = true
                        } label: {
                            Image(systemName: toDoListItem.isDone ? "checkmark.circle.fill" : "circle")
                        }
                    }
                    .onTapGesture {
                        editToDoListItem = toDoListItem
                        showingEditItemView = true
                    }
                    //}
                }
                .onDelete(perform: delete)
                /*.onTapGesture {
                 // editToDoListItem = toDoListItem
                 print("Tapped cell")
                 }*/
                //}
            }
            .navigationTitle("Tasks")
            .navigationBarItems(trailing: EditButton())
            //.navigationDestination(for: ToDoListItem.self, destination: EditItemView.init)
            
            .sheet(isPresented: $showingEditItemView) {
                EditItemView(toDoListItem: editToDoListItem!, editingItemPresented: $showingEditItemView , newTitle: editToDoListItem!.title)
                    .onDisappear {
                        if !canRemain {
                            // modelContext.insert(ToDoListItem(title: newTitle, dueDate: newDueDate))
                            modelContext.delete(editToDoListItem!)
                        }
                    }
            }
            
        }
    }
    
    func addNewToDo() {
        editToDoListItem = ToDoListItem(title: newToDo/*, createdDate: Date.now.timeIntervalSince1970*/)
        modelContext.insert(editToDoListItem!)
        // path = [thisToDoListItem]
        self.newToDo = ""
        //Ad auto generated id in the future.
    }
    
    func delete(at offsets : IndexSet) {
        for index in offsets {
            let toDoListItem = toDoListItems[index]
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
            let reminder = ToDoListItem(title: "Reminder \(count)", dueDate: (Date().timeIntervalSince1970 + 31536000))
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
    
    //ContentView()
    //.modelContainer(for: ToDoListItem.self/*modelContainer*/)
}
