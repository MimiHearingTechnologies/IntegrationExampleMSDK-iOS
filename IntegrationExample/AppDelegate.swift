//
//  AppDelegate.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 30.12.22.
//

import Foundation
import MimiCoreKit
import MimiUXKit
import MimiSDK

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    // MARK: Defaults
    
    private struct Defaults {
        static let mimiClientId = "de11b641c36b16b225ded485e0309b5e554c4d36e6568d36cba05a9d19b3cc71" // TODO: Replace with a new client id
    }
    
    // MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        startMimiCore()
        return true
    }
    
    // MARK: MimiSDK
    
    private func startMimiCore() {
        // Disable analytics
        Mimi.allowsUsageDataCollection = false
        
        // Start SDK
        Mimi.start(credentials: .client(id: Defaults.mimiClientId, secret: AppSecrets.mimiClientSecret),
                   delegate: self)
        
        #if DEBUG
        MimiCore.shared.log.levels = [.all]
        #endif
    }
}

extension AppDelegate: MimiCoreDelegate {
    
    func mimiCoreWasFoundUnserviceable(_ core: MimiCoreKit.MimiCore) {
        // TODO: Handle unserviceable core
    }
}
