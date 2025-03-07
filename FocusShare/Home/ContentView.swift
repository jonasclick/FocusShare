//
//  ContentView.swift
//  FocusShare
//
//  Created by Jonas Vetsch on 11.02.2025.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var viewModel = FocusViewModel()
  @State private var userIdToFollow: String = ""
  
  var body: some View {
    VStack {
      Text("My User Name: \(viewModel.userId)")
      
      Spacer()
      
      Text("Currently: \(viewModel.inFocus ? "Focused" : "Not Focused")")
        .padding()
      
      Button("Focus On") {
        viewModel.listenToFocusUpdates()
        viewModel.updateFocusStateToDb(inFocus: true)
      }
      .buttonStyle(BorderedProminentButtonStyle())
      
      
      Button("Focus Off") {
        viewModel.updateFocusStateToDb(inFocus: false)
      }
      
      
      Spacer()
      
      Text("You're following: \(userIdToFollow)")
      TextField("Enter user name to follow your friend.", text: $userIdToFollow)
      Button("Follow now") {
        viewModel.followUser(followingId: userIdToFollow)
      }
      .buttonStyle(BorderedButtonStyle())
      Button("Stop Following") {
        viewModel.stopFollowing()
        userIdToFollow = ""
      }
      
      Spacer()
      
    }
    .padding()
  }
  
  
}

#Preview {
  ContentView()
}
