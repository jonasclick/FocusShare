//
//  FocusOffView.swift
//  FocusShare
//
//  Created by Jonas Vetsch on 08.03.2025.
//

import SwiftUI

struct FocusOffView: View {
  
  @EnvironmentObject var viewModel: FocusViewModel
  
  var body: some View {
    
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
        Text("Currently not focussed.")
          .font(.system(size: 26))
          .fontWeight(.light)
          .foregroundStyle(.white)
          .shadow(color: .gray, radius: 15, x: 12, y: 12)
          .padding(.top, 340)
        
        Text("Your followers may interrupt you.")
          .font(.system(size: 16))
          .fontWeight(.light)
          .foregroundStyle(.white.opacity(0.8))
          .padding(.top, 55)
        
      }
    }
    .onTapGesture {
      viewModel.listenToFocusUpdates()
      viewModel.updateFocusStateToDb(inFocus: true)
    }
    
    
  }
}

#Preview {
  FocusOffView()
}
