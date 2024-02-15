//
//  PartnerFirmwareController.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 07.01.23.
//

import Foundation
import MimiCoreKit

/// A mock interface for communicating with the `Mimi Processing Library` on the Mimi enabled device's firmware.
protocol FirmwareControlling {

    func getTechLevel() async -> Int

    func getIsEnabled() async -> Bool
    func setIsEnabled(_ value: Bool) async throws

    func getIntensity() async -> Float
    func setIntensity(_ value: Float) async throws

    func setPreset(_ value: MimiPersonalization.Preset?) async throws
}

final actor PartnerFirmwareController: FirmwareControlling {

    private struct Defaults {
        static let simulatedDelay: TimeInterval = 0.1
    }
    
    private var isEnabled = true
    private var intensity: Float = 0.4
    
    func getTechLevel() -> Int {
        return 4
    }
    
    func getIsEnabled() -> Bool {
        return isEnabled
    }
    
    func setIsEnabled(_ value: Bool) async throws {
        try await Task.sleep(for: .seconds(Defaults.simulatedDelay))

        self.isEnabled = value
    }
    
    func getIntensity() -> Float {
        return intensity
    }
    
    func setIntensity(_ value: Float) async throws {
        try await Task.sleep(for: .seconds(Defaults.simulatedDelay))

        self.intensity = value
    }
    
    func setPreset(_ value: MimiCoreKit.MimiPersonalization.Preset?) async throws {
        try await Task.sleep(for: .seconds(Defaults.simulatedDelay))

        // set preset
    }
}
