//
//  ContentView.swift
//  FocusShare
//
//  Created by Jonas Vetsch on 11.02.2025.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var viewModel = FocusViewModel()
  
  var body: some View {
    VStack {
      Text("Focus State: \(viewModel.inFocus ? "Focused" : "Not Focused")")
      
      Button("Focus On") {
        viewModel.updateFocusState(inFocus: true)
      }
      .buttonStyle(BorderedProminentButtonStyle())
      .padding()
      
      
      Button("Focus Off") {
        viewModel.updateFocusState(inFocus: false)
      }
      .padding()
      
      
    }
    .padding()
  }
  
  
}

#Preview {
  ContentView()
}
