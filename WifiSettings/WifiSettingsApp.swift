//
//  WifiSettingsApp.swift
//  WifiSettings
//
//  Created by Ptera on 1/20/25.
//

import SwiftUI
import UIKitNavigation

@main
struct WifiSettingsApp: App {
    var body: some Scene {
        WindowGroup {
            UIViewControllerRepresenting {
                UINavigationController(
                    rootViewController:
                        WiFiSettingsViewController(model: WiFiSettingsModel(foundNetworks: .mocks))
                )
            }
        }
    }
}
