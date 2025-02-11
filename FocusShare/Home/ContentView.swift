//
//  ContentView.swift
//  FocusShare
//
//  Created by Jonas Vetsch on 11.02.2025.
//

import SwiftUI
import FirebaseFirestore

struct ContentView: View {
  let userId = "user123" // later change this to dynamic
  
  var body: some View {
    VStack {
      
      Button("Focus On") {
        updateFocusState(isFocused: true)
      }
      .buttonStyle(BorderedProminentButtonStyle())
      .padding()
      
      
      Button("Focus Off") {
        updateFocusState(isFocused: false)
      }
      .padding()
      
      
    }
    .padding()
  }
  
  
  func updateFocusState(isFocused: Bool) {
    let db = Firestore.firestore()
    db.collection("users").document(userId).setData([
      "username": "Jonas",
      "inFocus": isFocused
    ], merge: true) { error in
      if let error = error {
        print("DEBUG: Couldn't write to Database: \(error.localizedDescription)")
      } else {
        print("DEBUG: Focus state updated to: \(isFocused)")
      }
    }
  }
  
  
}

#Preview {
  ContentView()
}
