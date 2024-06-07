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
    @Published var intensity: Float = 0.0
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

    // MARK: - Parameter value application

    func applyIsEnabled(_ newValue: Bool) {
        let oldValue = isEnabled
        isEnabled = newValue
        
        Task {
            do {
                try await session.isEnabled.apply(newValue)
            } catch {
                await MainActor.run {
                    isEnabled = oldValue
                }
            }
        }
    }
    
    func applyIntensity(_ newValue: Float) {
        let oldValue = intensity
        intensity = newValue
        
        Task {
            do {
                try await session.intensity.apply(newValue)
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
                try await session.preset.load()
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
