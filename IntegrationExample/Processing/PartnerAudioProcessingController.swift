//
//  PartnerAudioProcessingController.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 30.12.22.
//

import Foundation
import Combine
import MimiCoreKit

/// A mock audio processing controller which illustrates the usage of Mimi Processing Parameter Applicators.
final class PartnerAudioProcessingController {
    
    private let session: MimiProcessingSession
    private let firmwareController: FirmwareControlling
    
    private var isEnabledApplicator: MimiProcessingParameterApplicator<Bool>!
    private var intensityApplicator: MimiProcessingParameterApplicator<Float>!
    private var presetApplicator: MimiProcessingParameterApplicator<MimiPersonalization.Preset?>!
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Init
    
    init(session: MimiProcessingSession, firmwareController: FirmwareControlling) {
        self.session = session
        self.firmwareController = firmwareController
        
        let isEnabledApplicator = makeIsEnabledApplicator(session: session, firmwareController: firmwareController)
        let intensityApplicator = makeIntensityApplicator(session: session, firmwareController: firmwareController)
        let presetApplicator = session.preset.applicator()
        
        setUpIsEnabledApplicator(isEnabledApplicator)
        setUpIntensityApplicator(intensityApplicator)
        setUpPresetApplicator(presetApplicator)
        
        // Hold strong references to parameter applicators
        self.intensityApplicator = intensityApplicator
        self.isEnabledApplicator = isEnabledApplicator
        self.presetApplicator = presetApplicator
    }
    
    private func makeIsEnabledApplicator(session: MimiProcessingSession, firmwareController: FirmwareControlling) -> MimiProcessingParameterApplicator<Bool> {
        let isEnabledValue = firmwareController.getIsEnabled()
        
        // Create an isEnabled applicator that is in sync with the isEnabled value on the firmware.
        let (isEnabledApplicator, _) = session.isEnabled.applicator(synchronizing: isEnabledValue)
        
        return isEnabledApplicator
    }
    
    private func makeIntensityApplicator(session: MimiProcessingSession, firmwareController: FirmwareControlling) -> MimiProcessingParameterApplicator<Float> {
        let intensityValue = firmwareController.getIntensity()
        
        // Create an intensity applicator that is in sync with the intensity value on the firmware.
        let (intensityApplicator, _) = session.intensity.applicator(synchronizing: intensityValue)
        
        return intensityApplicator
    }
    
    // MARK: Set up
    
    private func setUpIsEnabledApplicator(_ isEnabledApplicator: MimiProcessingParameterApplicator<Bool>) {
        isEnabledApplicator
            .canApply { value in
                // The goal `canApply` block is to verify if the `value` can be applied
                // before the actual call for the application of the value in the `apply` block
                // below.
                // If for any reason e.g. Mimi enabled headphones disconnected, the `value` cannot
                // be applied then return `false` otherwise return `true`
                
                return true
            }
            .apply { [weak self] value, resultHandler in
                
                self?.firmwareController.setIsEnabled(value) { result in
                    switch result {
                    case .success:
                        resultHandler(.success)
                        
                    case .failure(let error):
                        resultHandler(.failure(error))
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func setUpIntensityApplicator(_ intensityApplicator: MimiProcessingParameterApplicator<Float>) {
        intensityApplicator
            .canApply { value in
                // The goal `canApply` block is to verify if the `value` can be applied
                // before the actual call for the application of the value in the `apply` block
                // below.
                // If for any reason e.g. Mimi enabled headphones disconnected, the `value` cannot
                // be applied then return `false` otherwise return `true`
                
                return true
            }
            .apply { [weak self] value, resultHandler in
                 
                self?.firmwareController.setIntensity(value) { result in
                    switch result {
                    case .success:
                        resultHandler(.success)
                        
                    case .failure(let error):
                        resultHandler(.failure(error))
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func setUpPresetApplicator(_ presetApplicator: MimiProcessingParameterApplicator<MimiPersonalization.Preset?>) {
        
        presetApplicator
            .canApply { value in
                // The goal `canApply` block is to verify if the `value` can be applied
                // before the actual call for the application of the value in the `apply` block
                // below.
                // If for any reason e.g. Mimi enabled headphones disconnected, the `value` cannot
                // be applied then return `false` otherwise return `true`
                
                return true
            }
            .apply { [weak self] value, resultHandler in
                 
                self?.firmwareController.setPreset(value) { result in
                    switch result {
                    case .success:
                        resultHandler(.success)
                        
                    case .failure(let error):
                        resultHandler(.failure(error))
                    }
                }
            }
            .store(in: &cancellables)
    }
}
