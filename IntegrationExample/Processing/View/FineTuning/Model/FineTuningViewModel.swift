//
//  FineTuningViewModel.swift
//  MimiSDK iOS
//
//  Created by Salar on 7/22/22.
//  Copyright © 2022 Mimi Hearing Technologies GmbH. All rights reserved.
//

import Combine
import MimiCoreKit

final class FineTuningViewModel: ObservableObject {
    
    @Published private(set) var presets: [FineTuningBundlePreset] = []
    @Published var selectedPreset: FineTuningBundlePreset?

    private var lastAppliedPreset: FineTuningBundlePreset?
    private var cancellables = Set<AnyCancellable>()

    private let preset: MimiProcessingParameter<MimiPersonalization.Preset?>

    init(presetParameter: MimiProcessingParameter<MimiPersonalization.Preset?>) {
        self.preset = presetParameter
        subscribeToSessionDataSource()
    }

    func selectedPresetChanged(_ newPreset: FineTuningBundlePreset?) {
        Task {
            do {
                try await preset.apply(newPreset?.preset)
            } catch {
                await MainActor.run { [weak self] in
                    self?.selectedPreset = self?.lastAppliedPreset
                }
            }
        }
    }

    deinit {
        print("LOLOLOLOLO")
    }
}

private extension FineTuningViewModel {
    
    private func subscribeToSessionDataSource() {
        guard case let upDownDataSource as MimiUpDownPresetParameterDataSource = preset.dataSource?.type else {
            return
        }

        upDownDataSource.bundlePublisher
            .combineLatest(preset.valuePublisher)
            .removeDuplicates(by: { $0 == $1 })
            .receive(on: DispatchQueue.immediateWhenOnMainQueueScheduler)
            .sink { [weak self] bundle, preset in
                guard let preset else { return }
                self?.handleUpDownDataSource(preset: preset, bundle: bundle)
            }
            .store(in: &cancellables)
    }
    
    private func handleUpDownDataSource(preset: MimiPersonalization.Preset, bundle: MimiPersonalization.UpDownPresetBundle?) {
        guard let bundle = bundle else {
            return
        }
        
        setPresets(with: bundle)
        if let foundPreset = presets.first(where: { $0.id == preset.id }) {
            selectedPreset = foundPreset
            lastAppliedPreset = foundPreset
        } else {
            let recommendedPreset = FineTuningBundlePreset.recommended(with: bundle.default)
            selectedPreset = recommendedPreset
            lastAppliedPreset = recommendedPreset

            selectedPresetChanged(recommendedPreset)
        }
    }
    
    private func setPresets(with bundle: MimiPersonalization.UpDownPresetBundle) {
        var presetsArray: [FineTuningBundlePreset] = []
        
        if let softerPreset = bundle.down {
            presetsArray.append(.softer(with: softerPreset))
        }
        
        presetsArray.append(.recommended(with: bundle.default))
        
        if let richerPreset = bundle.up {
            presetsArray.append(.richer(with: richerPreset))
        }
        
        presets = presetsArray
    }
}
