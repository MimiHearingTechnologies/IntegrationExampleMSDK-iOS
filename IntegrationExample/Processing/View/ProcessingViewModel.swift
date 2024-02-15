//
//  ProcessingViewModel.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 09.01.23.
//

import SwiftUI
import Foundation
import Combine
import MimiCoreKit

final class ProcessingViewModel: ObservableObject {
    
    @Published var isHeadphoneConnected: Bool

    @Published var isSessionAvailable: Bool
    @Published var isEnabled: Bool = false
    @Published var intensity: Float = 0.0

    @Published var presetId: String?
    
    @Published var isUserLoggedIn: Bool
    
    private let core: MimiCore
    private let headphoneConnectivity: PartnerHeadphoneConnectivityController
    
    private var isEnabledApplyCancellable: AnyCancellable?
    private var intensityApplyCancellable: AnyCancellable?
    private var presetReloadCancellable: AnyCancellable?
    
    private var cancellables = Set<AnyCancellable>()
    
    private var session: MimiProcessingSession? {
        core.processing.session
    }

    // MARK: - Init

    init(core: MimiCore = .shared, headphoneConnectivity: PartnerHeadphoneConnectivityController) {
        self.core = core
        self.isSessionAvailable = core.processing.session != nil

        self.isHeadphoneConnected = headphoneConnectivity.state.value != .disconnected
        self.headphoneConnectivity = headphoneConnectivity

        self.isUserLoggedIn = core.auth.currentUser != nil
        core.auth.observable.addObserver(self)

        subscribeToHeadphoneConnectivityState()
        subscribeToProcessingSession()
    }

    // MARK: - Headpone connectivity

    func simulateHeadphoneConnection(isConnected: Bool) {
        headphoneConnectivity.simulateHeadphoneConnection(isConnected: isConnected)
    }

    // MARK: - Subscribers

    private func subscribeToProcessingSession() {
        core.processing.sessionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] session in
                guard let session else {
                    self?.isSessionAvailable = false
                    return
                }

                self?.subscribeToSessionParameterUpdates(session: session)
                self?.isHeadphoneConnected = true
                self?.isSessionAvailable = true
            }
            .store(in: &cancellables)
    }

    private func subscribeToSessionParameterUpdates(session: MimiProcessingSession) {
        session.isEnabled.valuePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.isEnabled = value
            }
            .store(in: &cancellables)
        
        session.intensity.valuePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.intensity = value
            }
            .store(in: &cancellables)
        
        session.preset.valuePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.presetId = value?.id
            }
            .store(in: &cancellables)
    }

    private func subscribeToHeadphoneConnectivityState() {
        headphoneConnectivity.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connectivityState in
                switch connectivityState {
                case .disconnected:
                    self?.isHeadphoneConnected = false
                case .connected:
                    self?.isHeadphoneConnected = true
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Parameter value application

    func applyIsEnabled(_ newValue: Bool) {
        let oldValue = isEnabled
        isEnabled = newValue

        Task {
            do {
                try await session?.isEnabled.apply(newValue)
            } catch {
                isEnabled = oldValue
            }
        }
    }
    
    func applyIntensity(_ newValue: Float) {
        let oldValue = intensity
        intensity = newValue
        
        Task {
            do {
                try await session?.intensity.apply(newValue)
            } catch {
                intensity = oldValue
            }
        }
    }
    
    func reloadPreset() {
        Task {
            do {
                try await session?.preset.load()
            } catch {
                // handle error
            }
        }
    }
}

extension ProcessingViewModel: MimiAuthControllerObservable {
    
    func authController(_ controller: MimiCoreKit.MimiAuthController, didUpdate currentUser: MimiCoreKit.MimiUser?, from oldUser: MimiCoreKit.MimiUser?, error: MimiCoreKit.MimiCoreError?) {
        self.isUserLoggedIn = currentUser != nil
    }
}
