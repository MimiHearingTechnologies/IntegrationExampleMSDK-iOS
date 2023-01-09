//
//  ProcessingView.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 30.12.22.
//

import SwiftUI
import MimiCoreKit

struct ProcessingView: View {
    
    @ObservedObject var viewModel: ProcessingViewModel
    
    init(viewModel: ProcessingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 32.0) {
            Text("Mimi Processing Parameters")
                .font(.title2)
            HStack {
                Toggle("IsEnabled", isOn: Binding<Bool>(get: { viewModel.isEnabled }, set: { value in
                    viewModel.applyIsEnabled(value)
                }))
            }
            VStack(spacing: 4.0) {
                HStack {
                    Text("Intensity")
                    Spacer()
                    Text("\(viewModel.intensity)")
                }
                Slider(value:Binding<Float>(get: { viewModel.intensity }, set: { value in
                    viewModel.applyIntensity(value)
                })) {
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
                Button("Reload") {
                    viewModel.reloadPreset()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(32.0)
    }
}
