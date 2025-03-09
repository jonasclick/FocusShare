//
//  FocusOnView.swift
//  FocusShare
//
//  Created by Jonas Vetsch on 08.03.2025.
//

import SwiftUI

struct FocusOnView: View {
  
  @EnvironmentObject var viewModel: FocusViewModel

    var body: some View {
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
          Text("Focus On")
            .font(.system(size: 32))
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .shadow(color: .gray, radius: 15, x: 12, y: 12)
            .padding(.top, 340)
          
          Text("We asked your followers not to interrupt you.")
            .font(.system(size: 16))
            .fontWeight(.light)
            .foregroundStyle(.white.opacity(0.8))
            .padding(.top, 55)
          
        }
      }
      .onTapGesture {
        viewModel.updateFocusStateToDb(inFocus: false)
      }
      
    }
}

#Preview {
    FocusOnView()
}
