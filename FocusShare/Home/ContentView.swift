//
//  ContentView.swift
//  FocusShare
//
//  Created by Jonas Vetsch on 11.02.2025.
//

import SwiftUI

struct ContentView: View {
  
  @Environment(\.colorScheme) private var colorScheme
  @StateObject var viewModel = FocusViewModel()
  @State private var userIdToFollow: String = ""
  @State private var isSettingsPresented: Bool = false
  @FocusState private var isSearchFocused: Bool
  
  
  var body: some View {
    GeometryReader { geo in
      
      ZStack {
        VStack {
          
          // MARK: Upper Half of screen (Focus Indicator)
          FocusView()
            .environmentObject(viewModel)
          
          // MARK: Lower Half of screen
          
          // Display Username and Privacy Remark
          VStack {
            // My Username
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
          .padding(.bottom, 50)
          
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
          .frame(width: geo.size.width)
        }
        .frame(width: geo.size.width)
        .ignoresSafeArea()
        
        
        // Darken the whole screen when isSearchFocused
        Rectangle()
          .foregroundStyle(.black)
          .opacity(isSearchFocused ? 0.85 : 0)
          .animation(.snappy, value: isSearchFocused)
        
        
        // MARK: Searchbar to follow someone
        ZStack {
          // Search bar to follow someone, moves up when focussed
          Rectangle()
            .foregroundStyle(Color(UIColor.systemBackground))
            .frame(width: 339, height: 50)
            .cornerRadius(42)
            .shadow(color: Color.primary.opacity(colorScheme == .light ? 0.15 : 0.25), radius: 15, x: 0, y: 5)
          
          HStack {
            // Username Entry Field / userIdToFollow Display Field
            Group {
              if viewModel.isFollowMode {
                Text("Following ") +
                Text(viewModel.followingUserId ?? "").bold()
              } else {
                TextField("Enter username to follow", text: $userIdToFollow)
                  .focused($isSearchFocused)
              }
            }
            .font(.system(size: 16))
            .fontWeight(.light)
            .foregroundStyle(Color.primary.opacity(0.5))
            .padding(.leading, 23)
            
            Spacer()
            
            // Button "Follow" / "Unfollow"
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
                .foregroundStyle(colorScheme == .light ? Color.primary : Color.primary.opacity(0.7))
                .padding(.trailing, 18)
            }
          }
          .frame(width: 339, height: 50)
        }
        .ignoresSafeArea()
        .offset(y: isSearchFocused ? 0 : 185)
        .animation(.snappy, value: isSearchFocused)
        
        // Errormessage if no internet connection
        if let error = viewModel.firestoreError {
          Text(error)
            .font(.footnote)
            .foregroundColor(.orange)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .transition(.opacity)
            .offset(y: 75)
        }
        
      }
      .sheet(isPresented: $isSettingsPresented) {
        SettingsView()
          .presentationDetents([.fraction(0.22)])
      }
    }
    .ignoresSafeArea()
  }
}

#Preview {
  ContentView()
}
