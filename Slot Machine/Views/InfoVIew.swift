//
//  InfoVIew.swift
//  Slot Machine
//
//  Created by Piyapong Ukoad on 31/10/2567 BE.
//

import SwiftUI

struct InfoVIew: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            LogoView()
            
            Spacer()
            
            Form {
                Section("About the Application") {
                    FormRowView(firstItem: "Application", secondItem: "Slot Machine")
                    FormRowView(firstItem: "Plamforms", secondItem: "iPhone, iPad, Mac")
                    FormRowView(firstItem: "Developer", secondItem: "John / Jane")
                    FormRowView(firstItem: "Designer", secondItem: "Robert Petras")
                    FormRowView(firstItem: "Music", secondItem: "Dan Lebowitz")
                    FormRowView(firstItem: "Website", secondItem: "swiftuimasterclass.com")
                    FormRowView(firstItem: "Copyright", secondItem: "2020 All rights reserved.")
                    FormRowView(firstItem: "Version", secondItem: "1.0.0")
                }
            }
            .font(.system(.body, design: .rounded))
        }
        .padding(.top, 40)
        .overlay(alignment: .topTrailing) {
            Button(action: {
                playSound(sound: "casino-chips", type: "mp3")
                dismiss()
            }) {
                Image(systemName: "xmark.circle")
                    .font(.title)
            }
            .padding(.top, 30)
            .padding(.trailing, 20)
            .tint(.secondary)
        }
        .onAppear {
            playSound(sound: "background-music", type: "mp3")
        }
        .onDisappear {
            audioPlayer?.stop()
        }
    }
}

struct FormRowView: View {
    var firstItem: String
    var secondItem: String
    var body: some View {
        HStack {
            Text(firstItem).foregroundStyle(Color.gray)
            Spacer()
            Text(secondItem)
        }
    }
}

#Preview {
    InfoVIew()
}
