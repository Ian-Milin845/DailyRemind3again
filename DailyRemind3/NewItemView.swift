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

import SwiftUI

struct NewItemView: View {
    @StateObject var viewModel = TaskStore()
    @Binding var newItemPresented: Bool
    
    var body: some View {
        VStack {
            Text("New Task")
                .font(.system(size: 32))
                .bold()
                .padding()
            
            Form {
                // Title
                TextField("Title", text: $viewModel.title)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                // Due Date
                DatePicker("Due Date", selection: $viewModel.dueDate)
                    .datePickerStyle(DefaultDatePickerStyle())
                
                // Button
                TLButton(
                    title: "Save",
                    background: .purple
                ) {
                    if viewModel.canSave {
                        viewModel.save()
                        newItemPresented = false
                    } else {
                        viewModel.showAlert = true
                    }
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text("Please fill in all fields and select due date that is today or newer"))
            }
        }
    }
}

#Preview {
    NewItemView(newItemPresented: Binding(get: {
        return true
    }, set: { _ in
        
    }))
}
