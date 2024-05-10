//
//  ProcessingParametersView.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 10.05.24.
//

import SwiftUI

struct ProcessingParametersView: View {

    @ObservedObject private var viewModel: ProcessingParametersViewModel

    init(viewModel: ProcessingParametersViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 24.0) {
            Text("Processing Parameters")
                .font(.title2)
            HStack {
                Toggle("IsEnabled", isOn: Binding<Bool>(get: { viewModel.isEnabled },
                                                        set: { viewModel.applyIsEnabled($0) }))
            }
            VStack(spacing: 4.0) {
                HStack {
                    Text("Intensity")
                    Spacer()
                    Text("\(viewModel.intensity)")
                }

                DebouncedSlider(value: Binding<Float>(get: { viewModel.intensity },
                                                      set: { viewModel.applyIntensity($0) })) {
                    Text("Intensity")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("1")
                }
            }
            VStack {
                HStack {
                    Text("Preset")
                    Spacer()
                    Text(viewModel.presetId ?? "nil")
                        .font(.caption)
                }
                if viewModel.isUserLoggedIn {
                    Button("Reload") {
                        viewModel.reloadPreset()
                    }
                    .buttonStyle(.bordered)
                } else {
                    Text("⚠️ User not logged in")
                }
            }
        }
    }
}
