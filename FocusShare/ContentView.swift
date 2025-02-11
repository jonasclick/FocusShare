//
//  ContentView.swift
//  FocusShare
//
//  Created by Jonas Vetsch on 11.02.2025.
//

import SwiftUI
import FirebaseFirestore

struct ContentView: View {
  var body: some View {
    VStack {
      Button("Test Firestore") {
        print("DEBUG: Button pressed.")
        let db = Firestore.firestore()
        db.collection("test").document("demo").setData(["message": "Hello Firebase from Xcode!"]) { error in
          if let error = error {
            print("DEBUG: Fehler beim Schreiben in Firestore: \(error.localizedDescription)")
          } else {
            print("DEBUG: Firestore-Verbindung erfolgreich hergestellt.")
          }
        }
      }
      .buttonStyle(BorderedProminentButtonStyle())
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
