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
import Combine

final class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    
    private let firmwareController: FirmwareControlling = PartnerFirmwareController()
    private let headphoneConnectivityController = PartnerHeadphoneConnectivityController()
    private var audioProcessingController: PartnerAudioProcessingController!
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        startMimiCore()
        
        // Observe headphone connectivity state changes
        observeHeadphoneConnectivityState()
        
        return true
    }
    
    // Simulate a headphone connection, and as a result, activate the processing session
    func simulateHeadphoneConnection(isConnected: Bool) {
        headphoneConnectivityController.simulateHeadphoneConnection(isConnected: isConnected)
    }
    
    private func observeHeadphoneConnectivityState() {
        headphoneConnectivityController.state
            .sink { state in
                switch state {
                    // Activate processing when headphones are connected
                case .connected:
                    do {
                        let session = try self.activateMimiProcessing(techLevel: self.firmwareController.getTechLevel())
                        self.audioProcessingController = PartnerAudioProcessingController(session: session, firmwareController: self.firmwareController)
                    } catch {
                        fatalError("Failed to launch Mimi Processing:  \(error.localizedDescription)")
                    }
                case .disconnected:
                    // Handle headphone disconnected state
                    MimiCore.shared.processing.deactivate()
                    
                    return
                }
            }
            .store(in: &cancellables)
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
