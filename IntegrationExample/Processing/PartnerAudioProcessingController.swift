//
//  PartnerAudioProcessingController.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 30.12.22.
//

import Foundation
import SwiftUI
import Combine
import MimiCoreKit

/// A mock audio processing controller which illustrates the usage of Mimi Processing Parameter Applicators.
final actor PartnerAudioProcessingController: ObservableObject {

    private let session: MimiProcessingSession
    private let firmwareController: FirmwareControlling
    
    private var isEnabledApplicator: MimiProcessingParameterApplicator<Bool>!
    private var intensityApplicator: MimiProcessingParameterApplicator<Float>!
    private var presetApplicator: MimiProcessingParameterApplicator<MimiPersonalization.Preset?>!

    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Init
    
    init(session: MimiProcessingSession, firmwareController: FirmwareControlling) async {
        self.session = session
        self.firmwareController = firmwareController

        await makeIsEnabledApplicator(session: session, firmwareController: firmwareController)
        await makeIntensityApplicator(session: session, firmwareController: firmwareController)
        await makePresetApplicator(session: session, firmwareController: firmwareController)
    }
    
    private func makeIsEnabledApplicator(session: MimiProcessingSession, firmwareController: FirmwareControlling) async {
        let isEnabledValue = await firmwareController.getIsEnabled()

        // Create an isEnabled applicator that is in sync with the isEnabled value on the firmware.
        self.isEnabledApplicator = await session.isEnabled.addApplicator(apply: { [weak self] value in
            guard let self else { return }

            // If for any reason e.g. Mimi enabled headphones disconnected, the `value` cannot
            // be applied then throw an error here.

            try await self.firmwareController.setIsEnabled(value)
        })

        do {
            // Sync the applicator with the firmware isEnabled value.
            try await session.isEnabled.apply(isEnabledValue)
        } catch {
            // handle error
        }
    }
    
    private func makeIntensityApplicator(session: MimiProcessingSession, firmwareController: FirmwareControlling) async {
        let intensityValue = await firmwareController.getIntensity()

        // Create an intensity applicator that is in sync with the intensity value on the firmware.
        self.intensityApplicator = await session.intensity.addApplicator(apply: { [weak self] value in
            guard let self else { return }

            // If for any reason e.g. Mimi enabled headphones disconnected, the `value` cannot
            // be applied then throw an error here.

            try await self.firmwareController.setIntensity(value)
        })

        do {
            // Sync the applicator with the firmware intensity value.
            try await session.intensity.apply(intensityValue)
        } catch {
            // handle error
        }
    }
    
    // MARK: Set up
    
    private func makePresetApplicator(session: MimiProcessingSession, firmwareController: FirmwareControlling) async {

        // Create a preset applicator.
        self.presetApplicator = await session.preset.addApplicator(apply: { [weak self] value in
            guard let self else { return }

            // If for any reason e.g. Mimi enabled headphones disconnected, the `value` cannot
            // be applied then throw an error here.

            do {
                try await self.firmwareController.setPreset(value)
            } catch {
                // handle error
            }
        })
    }
}
