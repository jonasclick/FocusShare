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
      // Upper Screen Half (Focus Indicator)
      if viewModel.inFocus { FocusOnView() } else { FocusOffView() }
      

      // Lower Screen Half (Follow-Menu)
      Spacer()
      
      VStack {
        
        // Search bar to follow someone
        ZStack {
          Rectangle()
            .foregroundStyle(.white)
            .frame(width: 339, height: 50)
            .cornerRadius(42)
            .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 5)
          
          HStack {
            TextField("Search to follow someone", text: $userIdToFollow)
              .font(.system(size: 16))
              .fontWeight(.light)
              .foregroundStyle(.black.opacity(0.5))
              .padding(.leading, 22)
            Spacer()
            Text("Follow")
              .font(.system(size: 16))
              .fontWeight(.semibold)
              .padding(.trailing, 18)
          }
          .frame(width: 339, height: 50)
        }
        
        // Username information
        VStack {
          HStack (spacing: 3) {
            Text("Your username is")
              .fontWeight(.light)
            Text("Bear46")
              .fontWeight(.bold)
          }
          .padding(.top, 10)
          .font(.system(size: 14))
          
          Text("Only give out your username to people you trust.")
            .fontWeight(.light)
            .padding(.top, 5)
            .font(.system(size: 12))
          
          Text(viewModel.inFocus ? "viewModel in Focus" : "viewModel not in Focus")
            .padding(.top)
        }
        .opacity(0.54)
        
        
      }
      
      Spacer()
    }
    .ignoresSafeArea()
    .onChange(of: userIdToFollow) {
      print("DEBUG: userIdToFollow changed to: \(userIdToFollow)")
    }
    
    
    
    
    
    //    VStack {
    //      Text("My User Name: \(viewModel.userId)")
    //
    //      Spacer()
    //
    //      Text("Currently: \(viewModel.inFocus ? "Focused" : "Not Focused")")
    //        .padding()
    //
    //      Button("Focus On") {
    //        viewModel.listenToFocusUpdates()
    //        viewModel.updateFocusStateToDb(inFocus: true)
    //      }
    //      .buttonStyle(BorderedProminentButtonStyle())
    //
    //
    //      Button("Focus Off") {
    //        viewModel.updateFocusStateToDb(inFocus: false)
    //      }
    //
    //
    //      Spacer()
    //
    //      Text("You're following: \(userIdToFollow)")
    //      Button("Follow now") {
    //        viewModel.followUser(followingId: userIdToFollow)
    //      }
    //      .buttonStyle(BorderedButtonStyle())
    //      Button("Stop Following") {
    //        viewModel.stopFollowing()
    //        userIdToFollow = ""
    //      }
    //
    //      Spacer()
    //
    //    }
    //    .padding()
    //  }
    //
    
  }
}

#Preview {
  ContentView()
}
