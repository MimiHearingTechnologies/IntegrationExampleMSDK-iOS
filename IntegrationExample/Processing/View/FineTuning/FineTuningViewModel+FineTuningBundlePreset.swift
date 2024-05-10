//
//  FineTuningBundlePreset.swift
//  MimiSDK iOS
//
//  Created by Salar on 7/22/22.
//  Copyright © 2022 Mimi Hearing Technologies GmbH. All rights reserved.
//

import Foundation
import MimiCoreKit

extension FineTuningViewModel {

    struct FineTuningBundlePreset: Hashable {
        let id: String
        let title: String
        let preset: MimiPersonalization.Preset
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: FineTuningBundlePreset, rhs: FineTuningBundlePreset) -> Bool {
            return lhs.id == rhs.id
        }
    }
}

extension FineTuningViewModel.FineTuningBundlePreset {
    
    static func softer(with preset: MimiPersonalization.Preset) -> Self {
        Self(
            id: preset.id,
            title: "Soft",
            preset: preset
        )
    }
    
    static func recommended(with preset: MimiPersonalization.Preset) -> Self {
        Self(
            id: preset.id,
            title: "Rec.",
            preset: preset
        )
    }
    
    static func richer(with preset: MimiPersonalization.Preset) -> Self {
        Self(
            id: preset.id,
            title: "Rich",
            preset: preset
        )
    }
}
