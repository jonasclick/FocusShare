//
//  FocusViewModel.swift
//  FocusShare
//
//  Created by Jonas Vetsch on 11.02.2025.
//

import Foundation
import FirebaseFirestore

class FocusViewModel: ObservableObject {
  @Published var inFocus: Bool = false
  private var db = Firestore.firestore()
  private var listener: ListenerRegistration?
  
  let userId = "user123" // TODO: Make this dynamic later
  
  init() {
    listenToFocusUpdates()
  }
  
  func listenToFocusUpdates() {
    listener = db.collection("users").document(userId)
      .addSnapshotListener { snapshot, error in
        if let data = snapshot?.data(), let focusState = data["inFocus"] as? Bool {
          DispatchQueue.main.async {
            self.inFocus = focusState
          }
        }
      }
  }
  
  
  func updateFocusState(inFocus: Bool) {
    let db = Firestore.firestore()
    db.collection("users").document(userId).setData(
      ["inFocus": inFocus], merge: true) { error in
        if let error = error {
          print("DEBUG: updateFocusState() couldn't write to Database: \(error.localizedDescription)")
        } else {
          print("DEBUG: Focus state updated in db to: \(inFocus)")
        }
      }
  }
  
  deinit {
    listener?.remove() // remove listener when ViewModel unloads from memory
  }
  
  
}
