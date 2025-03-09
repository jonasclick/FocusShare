//
//  FollowView.swift
//  FocusShare
//
//  Created by Jonas Vetsch on 09.03.2025.
//

import SwiftUI

struct FollowView: View {
  
  @EnvironmentObject var viewModel: FocusViewModel
  
  var body: some View {
    
    if viewModel.inFocus {
      
      // MARK: The followed user is in focus
      ZStack {
        
        // Background Image
        Image("TreeBackgroundBright")
          .resizable()
          .aspectRatio(contentMode: .fit)
        
        // Circle with Focus Symbol
        ZStack {
          Circle()
            .foregroundStyle(.white)
            .frame(width: 103)
            .shadow(color: .gray, radius: 15, x: 12, y: 12)
          
          Image(systemName: "person.fill.viewfinder")
            .font(.system(size: 57))
        }
        
        // Focus Information Text
        VStack {
          Text((viewModel.followingUserId ?? "") + " is in focus")
            .font(.system(size: 32))
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .shadow(color: .gray, radius: 15, x: 12, y: 12)
            .padding(.top, 340)
          
          
          Group {
            Text("Interrupt ")
              .fontWeight(.light) +
            Text(viewModel.followingUserId ?? "")
              .bold() +
            Text(" only when necessary.")
              .fontWeight(.light)
          }
          .font(.system(size: 16))
          .foregroundStyle(.white.opacity(0.8))
          .padding(.top, 55)
        }
      }
    
      
      
    
    } else {
      
      // MARK: The followed user is NOT in focus
      ZStack {
        
        // Background Image
        Image("TreeBackgroundDark")
          .resizable()
          .aspectRatio(contentMode: .fit)
        
        // Circle with Focus Symbol
        ZStack {
          Circle()
            .foregroundStyle(.white)
            .frame(width: 103)
            .shadow(color: .gray, radius: 15, x: 12, y: 12)
            .opacity(0.67)
          
          Image(systemName: "person.fill")
            .font(.system(size: 57))
            .opacity(0.25)
        }
        
        // Focus Information Text
        VStack {
          Group {
            Text(viewModel.followingUserId ?? "")
              .bold() +
            Text(" is currently\nnot focussed.")
              .fontWeight(.light)
          }
            .font(.system(size: 26))
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .shadow(color: .gray, radius: 15, x: 12, y: 12)
            .padding(.top, 320)
          
          
          Group {
            Text("You may interrupt ")
              .fontWeight(.light) +
            Text("\(viewModel.followingUserId ?? "").")
              .bold()
          }
          .font(.system(size: 16))
          .foregroundStyle(.white.opacity(0.8))
          .padding(.top, 35)
        }
      }
    }
  }
}


#Preview {
  FollowView()
}
