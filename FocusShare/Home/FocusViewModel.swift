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
  @Published var isFollowMode: Bool = false
  @Published var followingUserId: String? = nil
  @Published var isUserIdReady: Bool = false
  private var db = Firestore.firestore()
  private var listener: ListenerRegistration?
  private let userIdKey = "focusShareUserId"
  
  var userId: String
  
  
  
  init() {
    if let savedUserId = UserDefaults.standard.string(forKey: userIdKey) {
      self.userId = savedUserId
      self.isUserIdReady = true
      print("DEBUG: Found existing UserId in UserDefaults: \(savedUserId)")
    } else {
      self.userId = ""
      generateUniqueUserId()
    }
  }
  
  
  /// Generate a **unique** User ID (meaningful word + number)
  private func generateUniqueUserId() {
    let newUserId = FocusViewModel.generateRandomUserId()
    
    db.collection("users").document(newUserId).getDocument { snapshot, error in
      if let snapshot = snapshot, snapshot.exists {
        print("DEBUG: Re-Generating User ID, as \(newUserId) already exists.")
        self.generateUniqueUserId()
      } else {
        print("DEBUG: Generated User ID \(newUserId), which is unique.")
        UserDefaults.standard.set(newUserId, forKey: self.userIdKey)
        self.userId = newUserId
        self.saveUserIdToFirestore()
        self.isUserIdReady = true
      }
    }
  }
  
  
  /// Save the generated user id to firestore
  private func saveUserIdToFirestore() {
    db.collection("users").document(userId).setData([
      "username": userId,
      "inFocus": false
    ], merge: true) { error in
      if let error = error {
        print("DEBUG: Could not save user id to db: \(error.localizedDescription)")
      } else {
        print("DEBUG: User id saved to db: \(self.userId)")
      }
    }
  }
  
  
  /// Generate a random ID from a word + number (example: Squirrel23)
  private static func generateRandomUserId() -> String {
    let words = ["Squirrel", "Fox", "Rabbit", "Owl", "Mouse", "Bear", "Horse", "Turtle", "Parrot", "Sheep"]
    let randomWord = words.randomElement() ?? "User"
    let randomNumber = Int.random(in: 10...99)
    return "\(randomWord)\(randomNumber)" // example: Squirrel23
  }
  
  /// Listen to own focus updates
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
  
  
  /// Follow focus state of another user
  func followUser(followingId: String) {
    // If user doesn't specify a username, return.
    guard followingId.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
      return
    }
    self.followingUserId = followingId
    listener?.remove()
    listener = db.collection("users").document(followingId)
      .addSnapshotListener { snapshot, error in
        if let data = snapshot?.data(), let focusState = data["inFocus"] as? Bool {
          DispatchQueue.main.async {
            self.inFocus = focusState
          }
        }
      }
    self.isFollowMode = true
  }
  
  
  /// Save / update user's own focus state to db
  func updateFocusStateToDb(inFocus: Bool) {
    guard followingUserId == nil else {
      print("DEBUG: You cannot start a focus while following another user.")
      return
    }
    
    db.collection("users").document(userId).setData([
      "inFocus": inFocus,
      "lastUpdate": Date()
    ], merge: true) { error in
      if let error = error {
        print("DEBUG: Could not save focus state to db: \(error.localizedDescription)")
      } else {
        print("DEBUG: Focus state updated to db for \(self.userId): \(inFocus)")
      }
    }
  }
  
  
  /// Stop following another user
  func stopFollowing() {
    listener?.remove()
    print("DEBUG: Stopped following user \(followingUserId ?? "unknown").")
    followingUserId = nil
    isFollowMode = false
  }
  
  
  deinit {
    listener?.remove() // remove listener when ViewModel unloads from memory
  }
}
