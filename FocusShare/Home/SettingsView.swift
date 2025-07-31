//
//  SettingsView.swift
//  FocusShare
//
//  Created by Jonas Vetsch on 27.07.2025.
//
import SwiftUI

struct SettingsView: View {
  
  @Environment(\.dismiss) private var dismiss
  @Environment(\.colorScheme) private var colorScheme
  @State private var isGitHubPresented = false
  
  var body: some View {
    ZStack {
      
      VStack (alignment: .leading) {
        
        
        // Heading: About
        Text("About FocusShare")
          .font(.headline)
          .fontWeight(.medium)
          .padding(.top)
          .padding(.bottom, 10)
          .padding(.leading)
      
        Spacer()
        
        // MARK: Request feature or report a bug
        Link(destination: URL(string: "mailto:jonas@vetschmedia.com?subject=Feedback FocusShare App&body=Dear Developers")!, label: {
          ZStack {
            
            // Background
            Rectangle()
              .clipShape(RoundedRectangle(cornerRadius: 16))
              .foregroundStyle(Color(UIColor.systemBackground))
              .shadow(color: Color.primary.opacity(colorScheme == .light ? 0.15 : 0.1), radius: 15, x: 0, y: 5)

            // Icon and Text
            HStack {
              Image(systemName: "lightbulb.max")
                .frame(width: 11)
                .padding(.trailing, 5)
              Text("Request a feature or report a bug")
              Spacer()
            }
            .padding(.horizontal)
            .font(.system(size: 16))
            .fontWeight(.light)
          }
          .padding(.horizontal)
          .frame(height: 41)
          .padding(.bottom, -2) })
        
        
        // MARK: Link to GitHub Page
        Link(destination: URL(string: "https://github.com/jonasclick/FocusShare")!) {
          ZStack {
            Rectangle()
              .clipShape(RoundedRectangle(cornerRadius: 16))
              .foregroundStyle(Color(UIColor.systemBackground))
              .shadow(color: Color.primary.opacity(colorScheme == .light ? 0.15 : 0.1), radius: 15, x: 0, y: 5)
            HStack {
              Image(colorScheme == .light ? "github logo" : "github logo inverted")
                .resizable()
                .frame(width: 18, height: 18)
                .padding(.leading, -2)
              Text("This project is open source on GitHub")
              Spacer()
            }
            .padding(.horizontal)
            .font(.system(size: 16))
            .fontWeight(.light)
          }
          .padding(.horizontal)
          .frame(height: 41)
        }
        
        // Footer
        HStack {
          Text("Made with ♥︎ in Switzerland.")
          Spacer()
          // Display Version Number
          if let appVersionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            Text("Version \(appVersionNumber)")
          }
        }
        .padding(.horizontal)
        .font(.caption2)
        .opacity(0.5)
        .padding(.top, 2)
        .padding(.trailing, 2)
        .padding(.leading, 5)
        
      }
      .buttonStyle(PlainButtonStyle())
      
      // Close Button Top Right of Settings Sheet
      VStack {
        HStack {
          Spacer()
          Button(action: {
            dismiss()
          }, label: {
            Image("close button")
              .padding(10)
          })
        }
        Spacer()
      }
    }
  }
}


#Preview {
  SettingsView()
}
