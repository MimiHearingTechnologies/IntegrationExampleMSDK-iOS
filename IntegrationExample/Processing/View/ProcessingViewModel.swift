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
    @Published var isEnabled: Bool
    @Published var intensity: Float
    @Published var presetId: String?
    
    @Published var isUserLoggedIn: Bool
    
    private let core: MimiCore
    private let headphoneConnectivity: PartnerHeadphoneConnectivityController
    
    private var isEnabledApplyCancellable: AnyCancellable?
    private var intensityApplyCancellable: AnyCancellable?
    private var presetReloadCancellable: AnyCancellable?
    
    private var cancellables = Set<AnyCancellable>()
    
    private var session: MimiProcessingSession? {
        core.processing.session.value
    }
    
    init(core: MimiCore,
         headphoneConnectivity: PartnerHeadphoneConnectivityController) {
        self.core = core
        self.headphoneConnectivity = headphoneConnectivity
        
        self.isSessionAvailable = core.processing.session.value != nil
        self.isEnabled = core.processing.session.value?.isEnabled.value ?? false
        self.intensity = core.processing.session.value?.intensity.value ?? 0
        self.presetId = core.processing.session.value?.preset.value?.id
        
        self.isHeadphoneConnected = headphoneConnectivity.state.value != .disconnected
        
        self.isUserLoggedIn = core.auth.currentUser != nil
        
        core.auth.observable.addObserver(self)
        
        subscribeToProcessingSession()
        subscribeToHeadphoneConnectivityState()
    }
    
    private func subscribeToProcessingSession() {
        core.processing.session
            .sink { [weak self] session in
                guard let session else {
                    self?.isSessionAvailable = false
                    return
                }
                // Since the Slider sends updates continously, setting the delivery mode to discreet
                // allows us to debounce the updates.
                session.intensity.deliveryMode = .discrete(seconds: 0.2)
                self?.isSessionAvailable = true
                self?.subscribeToSessionParameterUpdates(session: session)
            }
            .store(in: &cancellables)
    }
    
    private func subscribeToSessionParameterUpdates(session: MimiProcessingSession) {
        session.isEnabled.$value
            .sink { [weak self] value in
                self?.isEnabled = value
            }
            .store(in: &cancellables)
        
        session.intensity.$value
            .sink { [weak self] value in
                self?.intensity = value
            }
            .store(in: &cancellables)
        
        session.preset.$value
            .sink { [weak self] value in
                self?.presetId = value?.id
            }
            .store(in: &cancellables)
    }
    
    private func subscribeToHeadphoneConnectivityState() {
        headphoneConnectivity.state
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
    
    func applyIsEnabled(_ newValue: Bool) {
        let oldValue = isEnabled
        isEnabled = newValue
        
        isEnabledApplyCancellable = session?.isEnabled.apply(newValue)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    self?.isEnabled = oldValue
                }
            } receiveValue: { _ in
            }
    }
    
    func applyIntensity(_ newValue: Float) {
        let oldValue = intensity
        intensity = newValue
        
        intensityApplyCancellable = session?.intensity.apply(newValue)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    self?.intensity = oldValue
                }
            } receiveValue: { _ in
            }
    }
    
    func reloadPreset() {
        presetReloadCancellable = session?.preset.reload()
            .sink { _ in
            } receiveValue: { [weak self] preset in
                self?.presetId = preset?.id
            }
    }
    
    func simulateHeadphoneConnection(isConnected: Bool) {
        headphoneConnectivity.simulateHeadphoneConnection(isConnected: isConnected)
    }
}

extension ProcessingViewModel: MimiAuthControllerObservable {
    
    func authController(_ controller: MimiCoreKit.MimiAuthController, didUpdate currentUser: MimiCoreKit.MimiUser?, from oldUser: MimiCoreKit.MimiUser?, error: MimiCoreKit.MimiCoreError?) {
        self.isUserLoggedIn = currentUser != nil
    }
}
