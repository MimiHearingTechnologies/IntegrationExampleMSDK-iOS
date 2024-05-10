//
//  FineTuningView.swift
//  MimiSDK iOS
//
//  Created by Salar on 7/22/22.
//  Copyright © 2022 Mimi Hearing Technologies GmbH. All rights reserved.
//

import SwiftUI

/// View that displays preset fine-tuning control and processing intensity slider.
struct FineTuningView: View {
    @ObservedObject private var viewModel: FineTuningViewModel

    init(viewModel: FineTuningViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 24.0) {
            Text("Fine-Tuning")
                .font(.title2)
            Picker("Fine Tuning", selection: $viewModel.selectedPreset) {
                ForEach(viewModel.presets, id: \.self) { item in
                    Text(item.title).tag(Optional(item))
                }
            }
            .onChange(of: viewModel.selectedPreset, perform: { newValue in
                viewModel.selectedPresetChanged(newValue)
            })
            .pickerStyle(.segmented)
        }
    }
}
