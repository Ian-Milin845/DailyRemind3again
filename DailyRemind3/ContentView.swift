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
// import Combine

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var toDoListItems: [ToDoListItem]
    //@State private var path = [ToDoListItem]()
    @State var newToDo : String = ""
    @State var showingEditItemView = false
    @State var editToDoListItem: ToDoListItem?
    
    var searchBar : some View {
        HStack {
            TextField("Enter in a new task", text: self.$newToDo)
            Button {
                // Action
                addNewToDo()
                showingEditItemView = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }
    
    var body: some View {
        NavigationStack(/*path: $path*/) {
            searchBar.padding()
            List {
                ForEach(toDoListItems) { toDoListItem in
                    //NavigationLink(value: toDoListItem) {
                    VStack(alignment: .leading) {
                        Text(toDoListItem.title)
                        
                        Text(toDoListItem.dueDate.formatted(date: .numeric, time: .standard))
                            .font(.caption)
                            .foregroundColor(Color.gray)
                        
                    }
                    .onTapGesture {
                        editToDoListItem = toDoListItem
                        showingEditItemView = true
                    }
                    //}
                }
                .onDelete(perform: delete)
                .onTapGesture {
                    // editToDoListItem = toDoListItem
                    print("Tapped cell")
                }
            }
            .navigationTitle("Tasks")
            .navigationBarItems(trailing: EditButton())
            //.navigationDestination(for: ToDoListItem.self, destination: EditItemView.init)
            
            .sheet(isPresented: $showingEditItemView) {
                EditItemView(toDoListItem: editToDoListItem!, editingItemPresented: $showingEditItemView /*, newTitle: $newToDo*/)
            }
        }
    }
    
    func addNewToDo() {
        editToDoListItem = ToDoListItem(title: newToDo)
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
}

#Preview {
    ContentView()
        .modelContainer(for: ToDoListItem.self)
}
