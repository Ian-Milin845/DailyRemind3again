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
    @State private var path = [ToDoListItem]()
    @State var newToDo : String = ""
    @State var showingNewItemView = false
    // var secToDoListItem: ToDoListItem?
    
    var searchBar : some View {
        HStack {
            TextField("Enter in a new task", text: self.$newToDo)
            Button {
                // Action
                addNewToDo()
                showingNewItemView = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }
    
    func addNewToDo() {
        //secToDoListItem = ToDoListItem(title: newToDo)
        //let newToDoListItem = secToDoListItem!
        let thisToDoListItem = ToDoListItem(title: "woah")
        modelContext.insert(thisToDoListItem)
        //path = [toDoListItem]
        self.newToDo = ""
        //Ad auto generated id in the future.
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            searchBar.padding()
            List {
                ForEach(toDoListItems) { toDoListItem in
                    Text(toDoListItem.title)
                }
                .onDelete(perform: self.delete)
            }
            .navigationBarTitle("Tasks")
            .navigationBarItems(trailing: EditButton())
            /*
            .sheet(isPresented: $showingNewItemView) {
                EditItemView(toDoListItem: secToDoListItem!, editItemPresented: $showingNewItemView)
            }*/
        }
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
