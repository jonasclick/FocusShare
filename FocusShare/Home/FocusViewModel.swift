//
//  FocusViewModel.swift
//  FocusShare
//
//  Created by Jonas Vetsch on 11.02.2025.
//

import Foundation
import FirebaseFirestore

class FocusViewModel: ObservableObject {
  @Published var userId: String
  @Published var inFocus: Bool = false
  @Published var followingUserId: String? = nil
  @Published var isFollowMode: Bool = false
  @Published var firestoreError: String? = nil
  
  private var db = Firestore.firestore()
  private var listener: ListenerRegistration?
  private let userIdKey = "focusShareUserId"
  private var syncStatusListener: ListenerRegistration?
  private var pendingWriteDelayWorkItem: DispatchWorkItem?
  
  init() {
    // If not first startup: Retrieve user id from UserDefaults
    if let savedUserId = UserDefaults.standard.string(forKey: userIdKey) {
      self.userId = savedUserId
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
  
  // Listener to get focus updates (for when own focus changes to not in focus
  func listenToFocusUpdates() {
    // Start a listener onto the DB
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
    
    db.collection("users").document(userId).setData(["inFocus": inFocus], merge: true) { error in
      if let error = error {
        print("DEBUG: Could not save focus state to db: \(error.localizedDescription)")
      } else {
        print("DEBUG: Focus state updated locally for \(self.userId): \(inFocus)")
        // Start monitoring to see if the update gets synched to DB
        // this is done in order to detect if device has no network connection
        self.monitorSyncStatus()
        
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
  
  
  // Handle no internet connection (Firestore can store pending writes,
  // but this is to inform the user that his update hasn't been written.
  // In order to not let the error pop up quickly after every focus change,
  // checking the internet connection gets scheduled / delayed 1 second.
  private func monitorSyncStatus() {
    syncStatusListener?.remove()
    
    syncStatusListener = db.collection("users").document(userId)
      .addSnapshotListener { snapshot, error in
        guard snapshot != nil else { return }
        
        // Cancel any previous scheduled checks
        self.pendingWriteDelayWorkItem?.cancel()
        
        if snapshot!.metadata.hasPendingWrites {
          let workItem = DispatchWorkItem {
            self.db.collection("users").document(self.userId).getDocument { freshSnapshot, _ in
              DispatchQueue.main.async {
                if freshSnapshot?.metadata.hasPendingWrites == true {
                  print("DEBUG: Focus update pending. Waiting for network connection...")
                  self.firestoreError = "Focus update pending. Waiting for network connection..."
                } else {
                  print("DEBUG: Sync completed before showing error. Skipping error display.")
                  self.firestoreError = nil
                }
              }
            }
          }
          
          self.pendingWriteDelayWorkItem = workItem
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
        } else {
          self.firestoreError = nil
        }
      }
  }
  
  
  
  deinit {
    listener?.remove() // remove listener when ViewModel unloads from memory
    syncStatusListener?.remove()
    pendingWriteDelayWorkItem?.cancel()
  }
}
