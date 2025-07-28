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
    // If not first startup: Retrieve user id from UserDefaults
    if let savedUserId = UserDefaults.standard.string(forKey: userIdKey) {
      self.userId = savedUserId
      self.isUserIdReady = true
      print("DEBUG: Found existing UserId in UserDefaults: \(savedUserId)")
    } else {
      // On first startup: Create a user ID.
      self.userId = ""
      generateUniqueUserId()
    }
  }
  
  
  /// Generate a unique User ID (meaningful word + number) - to be run only on first startup
  private func generateUniqueUserId() {
    
    // Generate a user ID string
    let newUserId = FocusViewModel.generateRandomUserId()
    
    // Check in DB if this ID already exists
    db.collection("users").document(newUserId).getDocument { snapshot, error in
      if let snapshot = snapshot, snapshot.exists {
        
        // CASE: ID exists already
        print("DEBUG: Re-Generating User ID, as \(newUserId) already exists.")
        
        // restart this function
        self.generateUniqueUserId()
      } else {
        
        // CASE: ID is unique and not used by any other user yet.
        print("DEBUG: Generated User ID \(newUserId), which is unique.")
        
        // Save ID in UserDefaults to make it persistent between app launches
        UserDefaults.standard.set(newUserId, forKey: self.userIdKey)
        
        // Pass ID to the ViewModel
        self.userId = newUserId
        
        // Create this new user in the Firestore DB
        self.saveUserIdToFirestore()
        
        // Tell the UI to render the User ID
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
  
  
  /// Generate a random ID from a word + number (example: Mouse23)
  private static func generateRandomUserId() -> String {
    // Collection of Animals
    let words = ["Squirrel", "Fox", "Rabbit", "Owl", "Mouse", "Bear", "Horse", "Turtle", "Parrot", "Sheep"]
    let randomWord = words.randomElement() ?? "User" // with Fallback
    let randomNumber = Int.random(in: 10...99)
    return "\(randomWord)\(randomNumber)" // Example: Mouse23
  }
  
  /// IS THIS ONLY TO LISTEN TO MY OWN UPDATES? DON'T UNDERSTAND YET......
  /// Listener to get focus updates of another user: Used when following another user
  func listenToFocusUpdates() {
    // Start a listener onto the DB
    listener = db.collection("users").document(userId)
      .addSnapshotListener { snapshot, error in
        if let data = snapshot?.data(), let focusState = data["inFocus"] as? Bool {
          DispatchQueue.main.async {
            /// Focus of another user uses same inFocus var. However, when listening to another
            /// User, we will have isFollowMode = true in order to display it in the UI correctly.
            self.inFocus = focusState
          }
        }
      }
  }
  
  
  /// Follow focus state of another user
  func followUser(followingId: String) {
    // If user didn't specify a username, return. Since we can't listen to noone.
    guard followingId.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
      return
    }
    self.followingUserId = followingId
    // Safeguard: Stop old listener, in case it's still existing.
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
