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
  @FocusState private var isSearchFocused: Bool
  
  var body: some View {
    
      ZStack {
        VStack {
          // MARK: Upper Screen Half (Focus Indicator)
          
          if !viewModel.isFollowMode {
            // Not following a user (default)
            FocusView()
              .environmentObject(viewModel)
          } else {
            // Following a user
            FollowView()
              .environmentObject(viewModel)
          }
          
          // MARK: Lower Screen Half (Follow-Menu)
          Spacer()
          
          VStack {
            
            
            // Username information
            VStack {
              Group {
                Text("Your username is ")
                  .fontWeight(.light) +
                Text(viewModel.userId)
                  .fontWeight(.bold) +
                Text(".")
                  .fontWeight(.bold)
              }
              .padding(.top, 40)
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
        
        // White background between the search bar and the rest of the view
        // to isolate the search bar when it's focused.
        Rectangle()
          .foregroundStyle(.black)
          .opacity(isSearchFocused ? 0.85 : 0)
          .animation(.snappy, value: isSearchFocused)

        // Search bar to follow someone, moves when focussed
        ZStack {
          Rectangle()
            .foregroundStyle(.white)
            .frame(width: 339, height: 50)
            .cornerRadius(42)
            .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 5)
          
          HStack {
            // Follow someone Textfield
            Group {
              if viewModel.isFollowMode {
                Text("Following ") +
                Text(viewModel.followingUserId ?? "")
                  .fontWeight(.bold)
              } else {
                TextField("Search to follow someone", text: $userIdToFollow)
                  .focused($isSearchFocused)
              }
            }
            .font(.system(size: 16))
            .fontWeight(.light)
            .foregroundStyle(.black.opacity(0.5))
            .padding(.leading, 23)
            
            Spacer()
            
            // Follow Button
            Button {
              if viewModel.isFollowMode {
                viewModel.stopFollowing()
              } else {
                viewModel.followUser(followingId: userIdToFollow)
                isSearchFocused = false
                userIdToFollow = ""
              }
            } label: {
              Text(viewModel.isFollowMode ? "Unfollow" : "Follow")
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .padding(.trailing, 18)
            }
          }
          .frame(width: 339, height: 50)
        }
        .offset(y: isSearchFocused ? 0 : 200)
        .animation(.snappy, value: isSearchFocused)
        
      }
      .ignoresSafeArea()
    
  }
}

#Preview {
  ContentView()
}
