//
//  IntegrationExampleApp.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 28.12.22.
//

import SwiftUI
import MimiCoreKit

@main
struct IntegrationExampleApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        appDelegate.headphoneConnectivityController.simulateHeadphoneConnection(isConnected: true)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(headphoneConnectivity: appDelegate.headphoneConnectivityController)
        }
    }
}
