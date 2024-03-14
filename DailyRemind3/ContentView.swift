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

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var taskStore = TaskStore()
    @State var newToDo : String = ""
    @State var showingNewItemView = false
    
    var searchBar : some View {
        HStack {
            TextField("Enter in a new task", text: self.$newToDo)
            Button {
                // Action
                self.addNewToDo()
                showingNewItemView = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }
    
    func addNewToDo() {
        taskStore.tasks.append(
            ToDoListItem(
                id: String(taskStore.tasks.count + 1),
                title: self.newToDo,
                dueDate: Date().timeIntervalSince1970 + 60,
                createdDate: Date().timeIntervalSince1970,
                isDone: false
            )
        )
        self.newToDo = ""
        //Ad auto generated id in the future.
    }
    var body: some View {
        NavigationView {
            VStack {
                searchBar.padding()
                List {
                    ForEach(self.taskStore.tasks) { task in
                        Text(task.title)
                    }
                    .onMove(perform: self.move)
                    .onDelete(perform: self.delete)
                }
                .navigationBarTitle("Tasks")
                .navigationBarItems(trailing: EditButton())
            }
            .sheet(isPresented: $showingNewItemView) {
                NewItemView(newItemPresented: $showingNewItemView)
            }
        }
    }
    func move(from source : IndexSet, to destination : Int) {
        taskStore.tasks.move(fromOffsets: source, toOffset: destination)
    }
    
    func delete(at offsets : IndexSet) {
        taskStore.tasks.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
