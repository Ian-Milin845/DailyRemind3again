//
//  NewItemView.swift
//  DailyRemind3
//
//  Created by Ian Milin on 3/11/24.
//

import SwiftUI

struct NewItemView: View {
    // @StateObject var viewModel = NewItemViewViewMode()
    var body: some View {
        VStack {
            Text("New Item")
                .font(.system(size: 32))
                .bold()
            
            Form {
                // Title
                // TextField("Title", text: $viewModel.title)
                
                // Due Date
                
                // Button
            }
        }
    }
}

#Preview {
    NewItemView()
}
