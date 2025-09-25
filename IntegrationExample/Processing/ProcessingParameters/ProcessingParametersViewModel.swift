//
//  ProcessingParametersViewModel.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 09.01.23.
//

import UIKit
import Combine
import MimiCoreKit

final class ProcessingParametersViewModel: ObservableObject {

    @Published var isEnabled: Bool = false
    @Published var intensity: Double = 0.0
    @Published var presetId: String?
    @Published var isUserLoggedIn: Bool

    private let session: MimiProcessingSession
    
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(session: MimiProcessingSession, auth: MimiAuthController) {
        self.session = session
        self.isUserLoggedIn = auth.currentUser != nil

        auth.observable.addObserver(self)
        subscribeToSessionParameterUpdates(session: session)
    }

    // MARK: - Subscribers

    private func subscribeToSessionParameterUpdates(session: MimiProcessingSession) {
        session.soundPersonalization?.media?.isEnabled.valuePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.isEnabled = value
            }
            .store(in: &cancellables)
        
        session.soundPersonalization?.media?.intensity.valuePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.intensity = value
            }
            .store(in: &cancellables)
        
        session.soundPersonalization?.media?.preset.valuePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.presetId = value?.id
            }
            .store(in: &cancellables)
    }

    // MARK: - Parameter value application

    func applyIsEnabled(_ newValue: Bool) {
        let oldValue = isEnabled
        isEnabled = newValue
        
        Task {
            do {
                try await session.soundPersonalization?.media?.isEnabled.apply(newValue)
            } catch {
                await MainActor.run {
                    isEnabled = oldValue
                }
            }
        }
    }
    
    func applyIntensity(_ newValue: Double) {
        let oldValue = intensity
        intensity = newValue
        
        Task {
            do {
                try await session.soundPersonalization?.media?.intensity.apply(newValue)
            } catch {
                await MainActor.run {
                    intensity = oldValue
                }
            }
        }
    }
    
    func reloadPreset() {
        Task {
            do {
                try await session.soundPersonalization?.media?.preset.load()
            } catch {
                // handle error
            }
        }
    }
}

extension ProcessingParametersViewModel: MimiAuthControllerObservable {
    
    func authController(_ controller: MimiCoreKit.MimiAuthController, didUpdate currentUser: MimiCoreKit.MimiUser?, from oldUser: MimiCoreKit.MimiUser?, error: MimiCoreKit.MimiCoreError?) {
        self.isUserLoggedIn = currentUser != nil
    }
}
