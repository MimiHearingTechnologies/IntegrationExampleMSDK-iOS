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
        static let mimiFittingTechLevel = 4 // This is an example value. Yours may be different.
    }
    
    // MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        startMimiCore()
        do {
            try activateMimiProcessing()
        } catch {
            fatalError("Failed to launch Mimi Processing:  \(error.localizedDescription)")
        }
        return true
    }
    
    // MARK: MimiSDK
    
    private func startMimiCore() {
        // Set up
        Mimi.allowsUsageDataCollection = false
        MimiCore.shared.log.levels = [.all]
        
        // Start SDK
        Mimi.start(credentials: .client(id: Defaults.mimiClientId, secret: AppSecrets.mimiClientSecret),
                   delegate: self)
    }
    
    private func activateMimiProcessing() throws {
        let processing = MimiCore.shared.processing
        
        // In the following, the session is instantiated with an UpDown datasource which provides (if available) a range of 3 presets - up, default & down. The UpDown datasource is the data source to be used for the so called Fine-tuning feature.
        let fitting = MimiPersonalization.Fitting.techLevel(Defaults.mimiFittingTechLevel)
        let _ = try processing.activate(presetDataSource: .upDown(.init(fitting: fitting)))
        
        // If only 1 preset, is desired, the Default datasource is to be used as follows.
//        let fitting = MimiPersonalization.Fitting.techLevel(Defaults.mimiFittingTechLevel)
//        try processing.activate(presetDataSource: .default(.init(fitting: fitting)))
    }
}

extension AppDelegate: MimiCoreDelegate {
    
    func mimiCoreWasFoundUnserviceable(_ core: MimiCoreKit.MimiCore) {
        // Handle unserviceable Mimi core
    }
}
