//
//  IntegrationExampleApp.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 28.12.22.
//

import SwiftUI

@main
struct IntegrationExampleApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
