//
//  ContentView.swift
//  FocusShare
//
//  Created by Jonas Vetsch on 11.02.2025.
//

import SwiftUI

struct ContentView: View {
  
  @StateObject var viewModel = FocusViewModel()
  @State private var userIdToFollow: String = ""
  
  var body: some View {
    
    VStack {
      // Upper Screen Half (Focus Indicator)
      if !viewModel.isFollowMode {
        
        // TODO: This if condition should be moved into the FocusView()
        if viewModel.inFocus {
          FocusOnView()
            .environmentObject(viewModel)
        } else {
          FocusOffView()
            .environmentObject(viewModel)
        }
      } else {
        FollowView()
          .environmentObject(viewModel)
      }
      
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
            Button {
              viewModel.followUser(followingId: userIdToFollow)
            } label: {
              Text("Follow")
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .padding(.trailing, 18)
            }
          }
          .frame(width: 339, height: 50)
        }
        
        // Username information
        VStack {
          HStack (spacing: 3) {
            Text("Your username is")
              .fontWeight(.light)
            Text(viewModel.userId)
              .fontWeight(.bold)
          }
          .padding(.top, 10)
          .font(.system(size: 14))
          
          Text("Only give out your username to people you trust.")
            .fontWeight(.light)
            .padding(.top, 5)
            .font(.system(size: 12))
          
        }
        .opacity(0.54)
      }
      
      Spacer()
    }
    .ignoresSafeArea()
  }
}

#Preview {
  ContentView()
}
