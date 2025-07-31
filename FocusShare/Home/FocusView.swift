//
//  FocusView.swift
//  FocusShare
//
//  Created by Jonas Vetsch on 09.03.2025.
//

import SwiftUI

struct FocusView: View {
  
  @EnvironmentObject var viewModel: FocusViewModel
  
  var body: some View {
    ZStack {
      
      // Background Image
      /// with GeometryReader to keep the image from moving when Follow Text Field is focussed
      GeometryReader { proxy in
        Image(viewModel.inFocus ? "TreeBackgroundBright" : "TreeBackgroundDark")
          .resizable()
          .scaledToFill()
          .frame(width: proxy.size.width, height: proxy.size.height)
          .clipped()
          .ignoresSafeArea()
      }
      
      
      VStack(alignment: .center) {
        // MARK: Circle with Focus Symbol
        ZStack {
          Circle()
            .foregroundStyle(.white)
            .frame(width: 103)
            .shadow(color: .black.opacity(0.7), radius: 15, x: 12, y: 12)
          
          Image(systemName: viewModel.inFocus ? "person.fill.viewfinder" : "person.fill")
            .font(.system(size: 57))
            .opacity(viewModel.inFocus ? 1 : 0.25)
            .animation(.snappy, value: viewModel.inFocus)
        }
        .padding(.bottom, 25)
        
        // MARK: Focus Information Text
        if !viewModel.isFollowMode {
          // CASE: Display users own focus information
          Text(viewModel.inFocus ? "Focus On" : "Currently not focussed.")
            .font(.system(size: viewModel.inFocus ? 32 : 26))
            .fontWeight(viewModel.inFocus ? .semibold : .light)
            .foregroundStyle(.white)
            .shadow(color: .gray, radius: 15, x: 12, y: 12)
            .frame(height: 23)
            .padding(.bottom, 5)
          
          Text(viewModel.inFocus ? "We asked your followers not to interrupt you." : "Your followers may interrupt you.")
            .font(.system(size: 16))
            .fontWeight(.light)
            .offset(y: 100)
            .foregroundStyle(.white.opacity(0.8))
        } else {
          // CASE: Display the followed user's focus information
          Text((viewModel.followingUserId ?? "") + " is in focus")
            .font(.system(size: 32))
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .shadow(color: .gray, radius: 15, x: 12, y: 12)
            .frame(height: 23)
            .padding(.bottom, 5)
          
          Group {
            Text("Interrupt ")
              .fontWeight(.light) +
            Text(viewModel.followingUserId ?? "")
              .bold() +
            Text(" only when necessary.")
              .fontWeight(.light)
          }
          .font(.system(size: 16))
          .offset(y:100)
          .foregroundStyle(.white.opacity(0.8))
        }
        
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
      .multilineTextAlignment(.center)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onTapGesture {
      if viewModel.isFollowMode { return }
      if viewModel.inFocus {
        // Turn off my focus
        viewModel.updateFocusStateToDb(inFocus: false)
      } else {
        // Turn on my focus
        viewModel.listenToFocusUpdates()
        viewModel.updateFocusStateToDb(inFocus: true)
      }
    }
  }
}

#Preview {
  FocusView()
    .environmentObject(FocusViewModel())
}
