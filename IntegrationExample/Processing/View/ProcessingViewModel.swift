//
//  ProcessingViewModel.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 09.01.23.
//

import Foundation
import Combine
import MimiCoreKit

final class ProcessingViewModel: ObservableObject {
    
    @Published var isEnabled: Bool
    @Published var intensity: Float
    @Published var presetId: String?
    
    private let session: MimiProcessingSession
    
    private var isEnabledApplyCancellable: AnyCancellable?
    private var intensityApplyCancellable: AnyCancellable?
    private var presetReloadCancellable: AnyCancellable?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(session: MimiProcessingSession) {
        self.isEnabled = session.isEnabled.value
        self.intensity = session.intensity.value
        self.presetId = session.preset.value?.id
        
        self.session = session
        
        // Since the Slider sends updates continously, setting the delivery mode to discreet
        // allows us to debounce the updates.
        session.intensity.deliveryMode = .discrete(seconds: 0.2)
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
