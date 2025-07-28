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
  @State private var isSettingsPresented: Bool = false
  @FocusState private var isSearchFocused: Bool
  
  
  var body: some View {
    
    Group {
      
      
      // MARK: Main Screen UI
      
      // On first startup, wait for username to be generated.
      if viewModel.isUserIdReady {
        
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
              // Inform User about their own Username
              VStack {
                HStack (spacing: 0) {
                  Text("Your username is ").fontWeight(.light)
                  Text("\(viewModel.userId).").bold()
                }
                .padding(.top, 125)
                .font(.system(size: 14))
                
                // Privacy Remark
                HStack {
                  Image(systemName: "person.badge.shield.exclamationmark")
                    .padding(.top, 10)
                    .padding(.trailing, 10)
                    .font(.system(size: 22))
                  VStack (alignment: .leading) {
                    Text("Your username lets others follow your focus.")
                    Text("Share it only with people you trust.")
                  }
                  .fontWeight(.light)
                  .padding(.top, 5)
                  .font(.system(size: 12))
                }
                .padding(.top, 15)
              }
              .opacity(0.54)
            }
            
            Spacer()
           
            // Settings Button
            HStack {
              Spacer()
              Image(systemName: "switch.2")
                .font(.system(size: 20))
                .padding(.bottom, 35)
                .padding(.trailing, 35)
                .opacity(0.54)
                .onTapGesture {
                  isSettingsPresented.toggle()
                }
            }
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
                  Text(viewModel.followingUserId ?? "").bold()
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
        .sheet(isPresented: $isSettingsPresented) {
          SettingsView()
            .presentationDetents([.fraction(0.22)])
        }
        
      } else {
        Text("Loading...")
      }
    }
  }
}

#Preview {
  ContentView()
}
