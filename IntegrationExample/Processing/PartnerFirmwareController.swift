//
//  PartnerFirmwareController.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 07.01.23.
//

import Foundation
import MimiCoreKit

/// An mock interface for communicating with the `Mimi Processing Library` on the Mimi enabled device's firmware.
protocol FirmwareControlling {
    
    func getTechLevel() -> Int
    
    func getIsEnabled() -> Bool
    func setIsEnabled(_ value: Bool, resultHandler: @escaping (Result<Bool, Error>) -> Void)
    
    func getIntensity() -> Float
    func setIntensity(_ value: Float, resultHandler: @escaping (Result<Float, Error>) -> Void)
    
    func setPreset(_ value: MimiPersonalization.Preset?, resultHandler: @escaping (Result<MimiPersonalization.Preset?, Error>) -> Void)
}

final class PartnerFirmwareController: FirmwareControlling {
    
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
    
    func setIsEnabled(_ value: Bool, resultHandler: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Defaults.simulatedDelay) {
            self.isEnabled = value
            resultHandler(.success(value))
        }
    }
    
    func getIntensity() -> Float {
        return intensity
    }
    
    func setIntensity(_ value: Float, resultHandler: @escaping (Result<Float, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Defaults.simulatedDelay) {
            self.intensity = value
            resultHandler(.success(value))
        }
    }
    
    func setPreset(_ value: MimiCoreKit.MimiPersonalization.Preset?, resultHandler: @escaping (Result<MimiCoreKit.MimiPersonalization.Preset?, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Defaults.simulatedDelay) {
            resultHandler(.success(value))
        }
    }
}
