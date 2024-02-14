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
    
    @ObservedObject var headphoneConnectivity: PartnerHeadphoneConnectivityController
    @Published var isHeadphoneConnected: Bool = true

    @Published var isEnabled: Bool
    @Published var intensity: Float
    @Published var presetId: String?
    
    @Published var isUserLoggedIn: Bool
    
    private let session: MimiProcessingSession
    
    private var isEnabledApplyCancellable: AnyCancellable?
    private var intensityApplyCancellable: AnyCancellable?
    private var presetReloadCancellable: AnyCancellable?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(session: MimiProcessingSession, 
         authController: MimiAuthController,
         headphoneConnectivity: PartnerHeadphoneConnectivityController) {
        self.isEnabled = session.isEnabled.value
        self.intensity = session.intensity.value
        self.presetId = session.preset.value?.id

        self.headphoneConnectivity = headphoneConnectivity

        self.isUserLoggedIn = authController.currentUser != nil
        
        self.session = session
        
        // Since the Slider sends updates continously, setting the delivery mode to discreet
        // allows us to debounce the updates.
        session.intensity.deliveryMode = .discrete(seconds: 0.2)
        
        authController.observable.addObserver(self)
        
        subscribeToSessionParameterUpdates()
    }
    
    private func subscribeToSessionParameterUpdates() {
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
    
    func applyIsEnabled(_ newValue: Bool) {
        let oldValue = isEnabled
        isEnabled = newValue
        
        isEnabledApplyCancellable = session.isEnabled.apply(newValue)
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
        
        intensityApplyCancellable = session.intensity.apply(newValue)
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
        presetReloadCancellable = session.preset.reload()
            .sink { _ in
            } receiveValue: { [weak self] preset in
                self?.presetId = preset?.id
            }
    }
}

extension ProcessingViewModel: MimiAuthControllerObservable {
    
    func authController(_ controller: MimiCoreKit.MimiAuthController, didUpdate currentUser: MimiCoreKit.MimiUser?, from oldUser: MimiCoreKit.MimiUser?, error: MimiCoreKit.MimiCoreError?) {
        self.isUserLoggedIn = currentUser != nil
    }
}
