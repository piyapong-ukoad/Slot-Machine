//
//  Slot_MachineApp.swift
//  Slot Machine
//
//  Created by Piyapong Ukoad on 31/10/2567 BE.
//

import SwiftUI

@main
struct Slot_MachineApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: UIScene.willConnectNotification)) { _ in
#if targetEnvironment(macCatalyst)
                    UIApplication.shared.connectedScenes
                        .compactMap { $0 as? UIWindowScene }
                        .forEach { windowScene in
                            windowScene.sizeRestrictions?.minimumSize = CGSize(width: 600, height: 800)
                            windowScene.sizeRestrictions?.maximumSize = CGSize(width: 600, height: 800)
                        }
#endif
                }
        }
    }
}
