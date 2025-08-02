
# FocusShare (iOS App)

**FocusShare** lets you share your real-life "Do Not Disturb" status with the people around you — without saying a word.  
It’s designed for deep work and distraction-free focus by eliminating accidental interruptions in shared spaces like homes, offices, or study environments.

<a href="https://focusshare.carrd.co/"  target="_blank">
<img src="https://github.com/jonasclick/hosting-images/blob/main/Header%20for%20GitHub.png"  alt="Image of the FocusShare App"  style="max-width: 100%; height: auto;">
</a>

This mobile app is developed for iOS in Swift using SwiftUI. It is available on the App Store and [can be downloaded here.](https://apps.apple.com/ch/app/focusshare/idYOUR_APP_ID)

### Why should I use FocusShare?

When you're trying to concentrate, even small unnecessary interruptions — like someone asking “Have heard about the new coffee shop downtown?” — can break your flow and cost you 20–30 minutes of deep work, as you need time to go back into your flow.

FocusShare solves this problem by letting you share your current focus status in real time with your partner, roommate, or coworker — so they see when you're in focus and when not.
FocusShare works instantly, with no account required, and gives others a clear signal: now’s not the time.

Whether you're working, coding, studying, or writing — this app helps you stay in the zone and reduce unnecessary distractions.



## Features

- **Real-Time Focus Sharing**: Share your current focus status with others around you.
- **Follow Mode**: See if someone else is currently focusing, so you know when to wait.
- **No Signup Required**: Focus is shared via auto-generated anonymous IDs — no account, no email, no personal info.
- **Minimal, Clean Design**: Built for clarity and presence, not complexity.




## Under the Hood: Tech Stack & Architecture

-   **Firebase Firestore Integration**: Real-time syncing of focus status between users using Firebase’s NoSQL database.
    
-   **Offline Awareness Logic**: Smart detection of connection issues using Firestore snapshot metadata: To inform users when their status hasn’t been communicated to followers yet.
    
-   **SwiftUI Architecture**: Built entirely with modern SwiftUI, using @StateObject, @Published, and onReceive for reactive UI updates.
    
-   **Minimal Persistence**: User IDs are stored locally with UserDefaults, avoiding Auth complexity while maintaining identity across sessions.
    
-   **App Store Optimization (ASO)**: Custom promotional text, subtitle, and keywords developed for maximum discoverability in the iOS App Store.
    
-   **Open Source**: Clean, well-documented codebase designed for easy extension or contribution.



## How to Contribute

Contributions are welcome! Whether you’d like to improve the codebase, fix bugs, or suggest features — feel free to open a pull request or issue. It's best if you reach out before starting your contribution efforts, so we can synch up about how you could contribute best.


### Design

This app is based on a minimal UX approach and has been prototyped in Figma. If you're a designer and want to help refine it, feel free to reach out.



### Localization

Currently available in English. Feel free to contribute translations.


## Privacy and Philosophy

FocusShare is **open source** and designed with privacy and simplicity at its core.  
No analytics, no tracking, no ads — just focus.

You can read the full [Privacy Policy here](https://focusshare.carrd.co/).


## Disclaimer

This app is a tool to help reduce real-life distractions, but it cannot guarantee interruption-free environments. Please use it with common sense and in good communication with those around you.

---

Made for and by people who value focus and deep work.
