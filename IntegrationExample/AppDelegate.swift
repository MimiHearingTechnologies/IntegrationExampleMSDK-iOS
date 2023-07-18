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
    
    private let firmwareController: FirmwareControlling = PartnerFirmwareController()
    private let headphoneConnectivityController = PartnerHeadphoneConnectivityController()
    private var audioProcessingController: PartnerAudioProcessingController!
    
    // MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        startMimiCore()
        do {
            let session = try activateMimiProcessing(techLevel: firmwareController.getTechLevel())
            self.audioProcessingController = PartnerAudioProcessingController(session: session, firmwareController: firmwareController)
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
        Mimi.start(credentials: .client(id: AppSecrets.mimiClientId, secret: AppSecrets.mimiClientSecret),
                   delegate: self)
        
        // Set up headphone connectivity
        // For more documentation on this see: https://mimihearingtechnologies.github.io/SDKDocs-iOS/master/connected-headphone-identification.html
        MimiCore.shared.test.connectedHeadphoneProvider = headphoneConnectivityController
    }
    
    private func activateMimiProcessing(techLevel: Int) throws -> MimiProcessingSession {
        let processing = MimiCore.shared.processing
        
        // In the following, the session is instantiated with an UpDown datasource which provides (if available) a range of 3 presets - up, default & down. The UpDown datasource is the data source to be used for the so called Fine-tuning feature.
        let fitting = MimiPersonalization.Fitting.techLevel(techLevel)
        return try processing.activate(presetDataSource: .upDown(.init(fitting: fitting)))
        
        // If only 1 preset, is desired, the Default datasource is to be used as follows.
//        let fitting = MimiPersonalization.Fitting.techLevel(techLevel)
//        return try processing.activate(presetDataSource: .default(.init(fitting: fitting)))
    }
}

extension AppDelegate: MimiCoreDelegate {
    
    func mimiCoreWasFoundUnserviceable(_ core: MimiCoreKit.MimiCore) {
        // Handle unserviceable Mimi core
    }
}
