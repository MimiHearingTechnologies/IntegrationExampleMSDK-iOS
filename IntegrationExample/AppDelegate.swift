//
//  AppDelegate.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 30.12.22.
//

import Foundation
import SwiftUI
import MimiCoreKit
import MimiUXKit
import MimiSDK
import Combine

final class AppDelegate: NSObject, UIApplicationDelegate {

    let headphoneConnectivityController = PartnerHeadphoneConnectivityController()
    private let firmwareController: FirmwareControlling = PartnerFirmwareController()
    private var audioProcessingController: PartnerAudioProcessingController!

    private var cancellables = Set<AnyCancellable>()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        startMimiCore()

        // Observe headphone connectivity state changes
        observeHeadphoneConnectivityState()
        
        return true
    }
    
    private func observeHeadphoneConnectivityState() {
        headphoneConnectivityController.state
            .sink { [weak self] state in
                guard let self else { return }

                switch state {
                    // Activate processing when headphones are connected
                case .connected:
                    Task {
                        do {
                            let session = try await self.activateMimiProcessing(techLevel: self.firmwareController.getTechLevel())
                            self.audioProcessingController = await PartnerAudioProcessingController(session: session, firmwareController: self.firmwareController)
                        } catch {
                            fatalError("Failed to launch Mimi Processing:  \(error.localizedDescription)")
                        }
                    }
                case .disconnected:
                    // Handle headphone disconnected state
                    Task {
                        await MimiCore.shared.processing.deactivate()
                    }

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
    
    private func activateMimiProcessing(techLevel: Int) async throws -> MimiProcessingSession {
//        let processing = MimiCore.shared.processing
        
        // In the following, the session is activated with processing configuration which provides (if available) a range of 3 presets - up, default & down. The UpDown datasource is the data source to be used for the so called Fine-tuning feature.
        let fitting = MimiPersonalization.Fitting.techLevel(techLevel)
        let configuration = mimiProcessingConfiguration {
                                Personalization {
                                    FineTuning(fitting: fitting)
                                }
                            }

        return try await MimiCore.shared.processing.activate(configuration: configuration)

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
